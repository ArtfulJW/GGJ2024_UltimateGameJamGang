extends Node2D
var y_mod = 0
var speed = 12
@onready var label = $Label
var pulse_in = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * speed
	position.y += sin(y_mod) * 7 * delta
	y_mod += 7 * delta
	
	if pulse_in:
		label.label_settings.font_color.a += delta / 1.5
		if label.label_settings.font_color.a >= 1:
			pulse_in = false
	else:
		label.label_settings.font_color.a -= delta / 1.5
		if label.label_settings.font_color.a <= 0:
			pulse_in = true
	
