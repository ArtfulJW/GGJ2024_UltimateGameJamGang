extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	GlobalData.continue_from_progress.connect(handle_restart)

func _on_button_pressed():
	get_tree().paused = false
	visible = false

func handle_restart():
	visible = true
	main.reset()

