extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D
@export var progress : Array[Control]
@onready var button = $Button

var splash_index = 0
var right_side_button_pos = Vector2(232,144)
var left_side_button_pos = Vector2(8,144)

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.player_died.connect(handle_player_died)

func handle_player_died():
	reset_timer.start()

func _on_button_pressed():
	visible = false
	progress[splash_index].visible = false
	get_tree().paused = false 
	# GlobalData.continue_from_progress.emit() 
	main.reset()

func _on_reset_timer_timeout():
	splash_index = get_splash_index()
	set_button_pos()
	get_tree().paused = true
	visible = true
	progress[splash_index].visible = true


func get_splash_index():
	if(GlobalData.score_good >= GlobalData.positive_progress_score_threshold):
		GlobalData.progress += 1
		if(GlobalData.progress > GlobalData.max_progress):
			return GlobalData.max_progress
		else:
			return GlobalData.progress
	else:
		return 0

func set_button_pos():
	match splash_index:
		0,2,4:
			button.set_position(left_side_button_pos)
		1,3,5,6:
			button.set_position(right_side_button_pos)
			
		
