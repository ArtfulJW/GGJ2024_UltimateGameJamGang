extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D
@export var progress : Array[Control]
@onready var button = $Button
@onready var bad_label = $Progress_BadResult/TextureRect/Bad_Label
@onready var animation_player = $AnimationPlayer
@onready var fader = $Fader


var bad_prompt_array
var bad_prompt_index = 0
var is_bad = false
var splash_index = 0
var right_side_button_pos = Vector2(226,144)
var left_side_button_pos = Vector2(8,144)

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.player_died.connect(handle_player_died)

func handle_player_died():
	reset_timer.start()

func _on_button_pressed():
	if is_bad:
		handle_is_bad()
	
	if is_bad:
		return
	
	fader.visible = true
	animation_player.play("fade_out")
	


func _on_animation_player_animation_finished(anim_name):
	fader.visible = false 
	visible = false
	progress[splash_index].visible = false
	fader.color.a = 0
	get_tree().paused = false 
	# GlobalData.continue_from_progress.emit() 
	main.reset()

func handle_is_bad():
	bad_prompt_index += 1
	if bad_prompt_index < bad_prompt_array.size():
		update_text()
	else:
		is_bad = false

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
		bad_prompt_array = main.prompt_generate_random(main.e_prompt_type.NEGATIVE_MAJOR)
		bad_prompt_index = 1
		is_bad = true
		update_text()
		return 0

func update_text():
	bad_label.text = bad_prompt_array[bad_prompt_index]

func set_button_pos():
	match splash_index:
		0,2,4,6,7,8,9:
			button.set_position(left_side_button_pos)
		1,3,5,10:
			button.set_position(right_side_button_pos)
			
		
