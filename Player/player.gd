extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const X_SPEED = 50

@onready var starting_position = position
@onready var slide_timer = $SlideTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d_slide = $CollisionShape2D_slide
@onready var collision_shape_2d_upright = $CollisionShape2D_upright
@onready var landing_vfx = $LandingVFX

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_sliding = false
var x_dest = 0.0
var is_dead = false
var just_jumped = false


func _ready():
	GlobalData.thought_passed_player.connect(on_thought_passed)
	GlobalData.player_died.connect(handle_player_died)
	x_dest = position.x

func _physics_process(delta):
	if is_dead:
		return
		
	handle_gravity(delta)
	handle_jump()
	handle_slide(delta)
	
	if(is_on_simulated_floor() and not is_sliding):
		animated_sprite_2d.play("running")
	
	if(abs(position.x - x_dest) > 0.01):
		position.x = lerp(position.x,x_dest,delta * X_SPEED)
	
	move_and_slide()
	
func is_on_simulated_floor():
	return position.y > starting_position.y

func handle_gravity(delta):
	if not is_on_simulated_floor():
		velocity.y += gravity * delta # * GlobalData.world_speed
		animated_sprite_2d.play("jumping")
	else:
		velocity.y = 0
		if just_jumped:
			landing_vfx.play("default")
			just_jumped = false

func handle_jump():
	if Input.is_action_just_pressed("ui_up") and is_on_simulated_floor() and !is_sliding:
		velocity.y = JUMP_VELOCITY # * GlobalData.world_speed
		just_jumped = true

func handle_slide(delta):
	if Input.is_action_just_pressed("ui_down") and is_on_simulated_floor() and !is_sliding:
		is_sliding = true
		slide_timer.start()
		animated_sprite_2d.play("sliding")
		collision_shape_2d_upright.disabled = true
		collision_shape_2d_slide.disabled = false
		
	if is_sliding and slide_timer.time_left <= 0:
		is_sliding = false
		collision_shape_2d_upright.disabled = false
		collision_shape_2d_slide.disabled = true

func on_thought_passed():
	x_dest += 16
	
func on_collision():
	x_dest -= 16

func handle_player_died():
	is_dead = true
