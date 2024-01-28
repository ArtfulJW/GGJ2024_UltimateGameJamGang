

extends Node2D

@export var MAX_X_SPEED: float = 15
@export var MIN_X_SPEED: float = 10
@export var MAX_Y_RANGE: float = 10
@export var MIN_Y_RANGE: float = 5
@export var MAX_ALPHA: float = 0.5
@export var MAX_WIGGLE_SALT: float = 10
@export var MIN_TEXT: int = 20
@export var MAX_TEXT: int = 50
@export var label_text = ""

@onready var label = $Label

var pulse_in = randi_range(0,1)
var y_wiggle = randf_range(0,2*PI)
var x_speed = randf_range(MIN_X_SPEED,MAX_X_SPEED)
var y_range = randf_range(MIN_Y_RANGE,MAX_Y_RANGE)
var wiggle_salt = randf_range(0, MAX_WIGGLE_SALT)
var text_size = randi_range(MIN_TEXT,MAX_TEXT)

func _ready():
	label.label_settings.font_color.a = randf_range(0,MAX_ALPHA)
	set_text(label_text)
	set_text_size(text_size)

func _process(delta):
	position.x -= delta * x_speed * GlobalData.world_speed
	position.y += sin(y_wiggle) * y_range * delta
	y_wiggle += wiggle_salt * delta
	
	if pulse_in == 0:
		label.label_settings.font_color.a += delta / 1.5
		if label.label_settings.font_color.a >= MAX_ALPHA:
			pulse_in = 1
	else:
		label.label_settings.font_color.a -= delta / 1.5
		if label.label_settings.font_color.a <= 0:
			pulse_in = 0

func set_text(text):
	label_text = text
	label.text = label_text
	
func set_text_size(size):
	label.label_settings.font_size = size
