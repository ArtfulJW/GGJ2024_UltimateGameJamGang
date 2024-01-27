extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const X_SPEED = 50

@onready var starting_position = position
@onready var slide_timer = $SlideTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_sliding = false
var x_dest = 0.0
var rotation_dest = 0.0
var skew_dest = 0.0


func _ready():
	GlobalData.thought_passed.connect(on_thought_passed)
	x_dest = position.x

func _physics_process(delta):
	
	handle_gravity(delta)
	handle_jump()
	handle_slide(delta)
	
	if(abs(position.x - x_dest) > 0.01):
		position.x = lerp(position.x,x_dest,delta * X_SPEED)
	
	move_and_slide()
	
func is_on_simulated_floor():
	return position.y > starting_position.y

func handle_gravity(delta):
	if not is_on_simulated_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func handle_jump():
	if Input.is_action_just_pressed("ui_up") and is_on_simulated_floor() and !is_sliding:
		velocity.y = JUMP_VELOCITY

func handle_slide(delta):
	if Input.is_action_just_pressed("ui_down") and is_on_simulated_floor() and !is_sliding:
		rotation_dest = -0.87
		skew_dest = -0.53
		is_sliding = true
		slide_timer.start()
		
	if is_sliding and slide_timer.time_left <= 0:
		rotation_dest = 0.0
		skew_dest = 0.0
		is_sliding = false

	if(abs(rotation - rotation_dest) > 0.01):
		rotation = lerp(rotation, rotation_dest, delta * X_SPEED)
		skew = lerp(skew, skew_dest, delta * X_SPEED)
		
func on_thought_passed():
	x_dest += 16
	
func on_collision():
	x_dest -= 16
