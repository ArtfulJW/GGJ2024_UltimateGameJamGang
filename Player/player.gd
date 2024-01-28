extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const X_SPEED = 1 # 3 #50

@onready var starting_position = position
@onready var slide_timer = $SlideTimer
@onready var jump_timer = $JumpTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d_slide = $CollisionShape2D_slide
@onready var collision_shape_2d_upright = $CollisionShape2D_upright

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_sliding = false
var slide_time			= 1.0;
var x_dest = 0.0
var is_dead = false

var y_speed		= 0;
var is_jumping 	= false;
var jump_time			= 0.1;
var jump_speed 			= -2.4 #-10000;
var jump_deceleration 	= 0.08 # 250
var gravity 			= 0.12 # 500;
var gravity_max			= 3.2 # 25000;
var floor_y				= GlobalData.screen_size_y - GlobalData.tile_size


func _ready():
	GlobalData.thought_passed_player.connect(on_thought_passed)
	GlobalData.player_died.connect(handle_player_died)
	x_dest = position.x
	
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
	
	
	if(is_on_simulated_floor() and not is_sliding):
		animated_sprite_2d.play("running")
	
	if(abs(position.x - x_dest) > 0.01):
		position.x = lerp(position.x, x_dest, delta_normal * X_SPEED)
	
	
	
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
		
	#handle_jump(delta)
	#handle_gravity(delta)
	#handle_slide(delta)
	#
	#if(is_on_simulated_floor() and not is_sliding):
		#animated_sprite_2d.play("running")
	#
	#if(abs(position.x - x_dest) > 0.01):
		#position.x = lerp(position.x,x_dest,delta * X_SPEED)
	#
	#move_and_slide()
	
	##ensure player doesn't go below floor
	#if position.y > floor_y:
		#position.y = floor_y;
		##velocity.y = 0;
		#y_speed = 0;
		#



func is_on_simulated_floor():
	#return position.y > starting_position.y
	return position.y >= floor_y

func handle_gravity(delta):
	
	if !is_jumping:
		if! is_on_simulated_floor():
			#velocity.y += gravity * delta * GlobalData.world_speed
			# apply gravity
			#velocity.y = min(gravity_max * GlobalData.world_speed, velocity.y + (gravity * delta * GlobalData.world_speed))
			if y_speed < 0:
				y_speed += (jump_deceleration * delta * GlobalData.world_speed)
			else:
				y_speed = min(gravity_max, y_speed + (gravity * delta * GlobalData.world_speed))
			print("applying gravity")
		
			# "floor" to floor
			if is_on_simulated_floor():
				#velocity.y = 0
				y_speed = 0
				position.y = floor_y;

func handle_jump(delta):
	
	# check to jump
	if !is_jumping and !is_sliding and Input.is_action_just_pressed("ui_up") and is_on_simulated_floor():
		is_jumping = true;
		jump_timer.start(jump_time / GlobalData.world_speed)
		#velocity.y = jump_speed * delta * GlobalData.world_speed
		y_speed = jump_speed # * delta * GlobalData.world_speed
		animated_sprite_2d.play("jumping")
		print("jump")
		
		

func _on_jump_timer_timeout() -> void:
	is_jumping = false;
	print("jump clear")
	pass

func handle_slide(delta):
	if Input.is_action_just_pressed("ui_down") and is_on_simulated_floor() and !is_sliding:
		is_sliding = true
		slide_timer.start(slide_time / GlobalData.world_speed)
		animated_sprite_2d.play("sliding")
		collision_shape_2d_upright.disabled = true
		collision_shape_2d_slide.disabled = false
		print("sliding")
		

func _on_slide_timer_timeout() -> void:
	is_sliding = false
	collision_shape_2d_upright.disabled = false
	collision_shape_2d_slide.disabled = true
	print("slide clear")
	pass

func on_thought_passed():
	x_dest += 16
	
func on_collision():
	x_dest -= 16

func handle_player_died():
	is_dead = true




