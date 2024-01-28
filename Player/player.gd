extends CharacterBody2D

#const JUMP_VELOCITY = -400.0
#const X_SPEED = 0.05 # 3 #50

@onready var starting_position = position
@onready var slide_timer = $SlideTimer
@onready var jump_timer = $JumpTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d_slide = $CollisionShape2D_slide
@onready var collision_shape_2d_upright = $CollisionShape2D_upright
@onready var landing_vfx = $LandingVFX
@onready var slide_vfx = $slide_vfx

var is_sliding = false
var slide_time			= 1.5;
var x_dest = 0.0
var is_dead = false
var should_trigger_landing_fx = false

var x_cloud_change_speed = 1;
var x_speedup_lerp_speed = 0.025;

var y_speed		= 0;
var is_jumping 	= false;
var jump_time			= 30.0/60.0;
var jump_speed 			= -3/3 #-10000;
var jump_deceleration 	= 0.166/3 # 250
var gravity 			= 0.166/3 # 500;
var gravity_max			= 3.33/3 # 25000;
var floor_y				= GlobalData.screen_size_y - GlobalData.tile_size
var x_max				= GlobalData.screen_size_x * 2.0/3.0
var x_min_death			= GlobalData.tile_size

func _ready():
	GlobalData.thought_passed_player.connect(on_thought_passed)
	GlobalData.player_died.connect(handle_player_died)
	x_dest = position.x
	Wwise.register_game_obj(self, self.name)
	
	#Connect the "timeout" signal to a method
	jump_timer.connect("timeout", _on_jump_timer_timeout)
	slide_timer.connect("timeout", _on_slide_timer_timeout)

func _process(delta):
	if is_dead:
		return
	
	
	# Figure out movement
	var delta_normal = delta / (1.0/60.0)	# normalized value
	handle_jump(delta_normal)
	handle_gravity(delta_normal)
	handle_slide(delta_normal)
	
	
	if(is_on_simulated_floor() and not is_sliding and not is_jumping):
		animated_sprite_2d.play("running")
	
	var x_pos_diff = x_dest - position.x
	if(abs(x_pos_diff) > 0):
		# the amount to move. Will favor the smaller of either move speed or distance to point. 
		#var _move_x = min(abs(x_pos_diff), x_cloud_change_speed * delta_normal * GlobalData.world_speed) * sign(x_pos_diff)
		#position.x += _move_x
		position.x = lerp(float(position.x), float(x_dest), min(1.0, x_speedup_lerp_speed * delta_normal * GlobalData.world_speed))
	
	
	
	# Apply speed
	position.y += y_speed * delta_normal * GlobalData.world_speed;
	
	
	
	#ensure player doesn't go below floor
	if position.y > floor_y:
		position.y = floor_y;
		#velocity.y = 0;
		y_speed = 0;
	
	pass

func _physics_process(delta):
	if is_dead:
		return


func is_on_simulated_floor():
	return position.y >= floor_y

func handle_gravity(delta):
	
	if !is_jumping:
		if! is_on_simulated_floor():
			if y_speed < 0:
				y_speed += (jump_deceleration * delta * GlobalData.world_speed)				
			else:
				y_speed = min(gravity_max, y_speed + (gravity * delta * GlobalData.world_speed))

			#print("applying gravity")
		
			# "floor" to floor
			if is_on_simulated_floor():
				#velocity.y = 0
				y_speed = 0
				position.y = floor_y;
		
		elif should_trigger_landing_fx:
			landing_vfx.play("default")
			# todo - Aryo put landing sound here
			should_trigger_landing_fx = false

func handle_jump(delta):
	
	# check to jump
	if !is_jumping and Input.is_action_just_pressed("ui_up") and is_on_simulated_floor():
		is_jumping = true;
		jump_timer.start(jump_time / GlobalData.world_speed)
		#velocity.y = jump_speed * delta * GlobalData.world_speed
		y_speed = jump_speed # * delta * GlobalData.world_speed
		animated_sprite_2d.play("jumping")
		
		Wwise.set_2d_position(self, get_global_transform(), 0)
		Wwise.post_event_id(AK.EVENTS.VOX_JUMP, self)
		
		# if I jump while sliding, end the slide early. 
		if is_sliding:
			slide_timer.start(0.01)
		print("jump")
		

func _on_jump_timer_timeout() -> void:
	is_jumping = false;
	should_trigger_landing_fx = true
	print("jump clear")
	pass


func handle_slide(delta):
	if Input.is_action_just_pressed("ui_down") and is_on_simulated_floor() and !is_sliding:
		is_sliding = true
		slide_timer.start(slide_time / GlobalData.world_speed)
		animated_sprite_2d.play("sliding")
		slide_vfx.play("default")
		collision_shape_2d_upright.disabled = true
		collision_shape_2d_slide.disabled = false
		print("sliding")
		Wwise.set_2d_position(self, get_global_transform(), 0)
		Wwise.post_event_id(AK.EVENTS.SFX_SLIDE, self)

func _on_slide_timer_timeout() -> void:
	is_sliding = false
	collision_shape_2d_upright.disabled = false
	collision_shape_2d_slide.disabled = true
	print("slide clear")
	pass

func on_thought_passed():
	x_dest = min(x_max, x_dest + GlobalData.tile_size)
	
func on_collision():
	x_dest = max(0, x_dest - GlobalData.tile_size * 3) 

func handle_player_died():
	is_dead = true

func reset():
	is_dead = false;
	position = starting_position
	is_sliding = false
	is_jumping = false;
	y_speed = 0;
	jump_timer.stop()
	slide_timer.stop()
	x_dest = starting_position.x
	should_trigger_landing_fx = false;
	
	pass

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.get_frame() in [1, 5] and is_on_simulated_floor():
		Wwise.set_2d_position(self, get_global_transform(), 0)
		Wwise.post_event_id(AK.EVENTS.SFX_FOOTSTEP, self)
