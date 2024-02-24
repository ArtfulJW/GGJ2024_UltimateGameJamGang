extends Control

@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var text_cycle_timer = $text_cycle_timer
@export var clouds : Array[Node2D]

var prompt_gen
var prompt_array
var prompt_ui_state

enum e_prompt_ui_state 
{
	HIDDEN,
	PROMPT,
	RESULT
}

func _ready():
	prompt_gen = get_node("/root/Main/PromptGenerator")
	GlobalData.thought_collide_bad.connect(update_text_prompt_bad)
	GlobalData.thought_collide_good.connect(update_text_prompt_good)
	GlobalData.restart.connect(reset_text)
	reset_text()

func update_text_prompt_good():
	update_text_prompt(prompt_gen.e_prompt_type.POSITIVE_MINOR)
	
func update_text_prompt_bad():
	update_text_prompt(prompt_gen.e_prompt_type.NEGATIVE_MINOR)
	
func reset_text():
	visible = false
	prompt_ui_state = e_prompt_ui_state.HIDDEN
	animation_player.stop()
	text_cycle_timer.stop()
	
func _on_text_cycle_timer_timeout():
	animation_player.speed_scale = 1
	animation_player.play("prompt_box_ui_text_transition")


	
func update_text_prompt(prompt_type):

	if prompt_ui_state != e_prompt_ui_state.HIDDEN:
		return
	
	var color = Color.WHITE
	
	if (prompt_type == prompt_gen.e_prompt_type.POSITIVE_MINOR):
		color = Color.AQUA
	
	for cloud in clouds:
		cloud.modulate = color
	
	prompt_ui_state = e_prompt_ui_state.PROMPT
	visible = true
	start_animation_sequence()
	prompt_array = prompt_gen.prompt_generate_random(prompt_type)
	update_text(1)

func start_animation_sequence():
	animation_player.speed_scale = 2
	animation_player.play("prompt_box_ui_cloud_animation")

func update_text_result():
	update_text(2)
	prompt_ui_state = e_prompt_ui_state.RESULT
	if(prompt_array):
		GlobalData.prompt_array_storage.append(prompt_array[1])
		GlobalData.prompt_array_storage.append(prompt_array[2])
		GlobalData.prompt_array_storage.append("\n")
		prompt_array = null
		
	
func update_text(i):
	text_cycle_timer.start()
	if(prompt_array):
		label.text = prompt_array[i]
