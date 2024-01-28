extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.player_died.connect(handle_player_died)


func handle_player_died():
	reset_timer.start()

func _on_button_pressed():
	visible = false
	get_tree().paused = false 
	# GlobalData.continue_from_progress.emit() 
	main.reset()

func _on_reset_timer_timeout():
	get_tree().paused = true
	visible = true
