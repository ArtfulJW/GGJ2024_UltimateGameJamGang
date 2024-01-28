extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	GlobalData.player_died.connect(handle_player_died)

func _on_button_pressed():
	get_tree().paused = false
	visible = false

func handle_player_died():
	reset_timer.start()
	
func _on_reset_timer_timeout():
	get_tree().paused = true
	visible = true
	main.reset()
