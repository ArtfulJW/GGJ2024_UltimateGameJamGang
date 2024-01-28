extends CanvasLayer

@onready var reset_timer = $ResetTimer
@onready var intro_beat = $intro_beat

@export var main : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	GlobalData.continue_from_progress.connect(handle_restart)

func _on_button_pressed():
	if intro_beat.visible == false:
		intro_beat.visible = true
		return
	
	get_tree().paused = false
	visible = false

func handle_restart():
	visible = true
	main.reset()

