extends CanvasLayer

@export var prompt_gen : Node2D
@onready var animation_player = $Prompt_Box/AnimationPlayer
@onready var label = $Prompt_Box/Control/NinePatchRect/ColorRect/Label
@onready var timer = $Timer
@onready var score_box = $Score_Box
@onready var prompt_box = $Prompt_Box

var start_text 
var prompt_array
var prompt_ui_state

enum e_prompt_ui_state 
{
	HIDDEN,
	PROMPT,
	RESULT
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	GlobalData.thought_collide_bad.connect(update_text_prompt_bad)
	GlobalData.thought_collide_good.connect(update_text_prompt_good)
	GlobalData.restart.connect(reset_text)
	start_text = label.text
	reset_text()
	
func _on_timer_timeout():
	match prompt_ui_state:
		e_prompt_ui_state.HIDDEN:
			pass
			
		e_prompt_ui_state.PROMPT:
			update_text_result()
			pass
			
		e_prompt_ui_state.RESULT:
			animation_player.play("shrink_textbox")
			pass

func reset_text():
	label.text = start_text
	prompt_box.visible = false
	prompt_ui_state = e_prompt_ui_state.HIDDEN
	
func update_text_prompt_good():
	update_text_prompt(prompt_gen.e_prompt_type.POSITIVE_MINOR)
	
func update_text_prompt_bad():
	update_text_prompt(prompt_gen.e_prompt_type.NEGATIVE_MINOR)
	
func update_text_prompt(prompt_type):

	if prompt_ui_state != e_prompt_ui_state.HIDDEN:
		return
		
	prompt_ui_state = e_prompt_ui_state.PROMPT
	prompt_box.visible = true
	animation_player.play("grow_textbox")
	prompt_array = prompt_gen.prompt_generate_random(prompt_type)
	update_text(1)

func update_text_result():
	update_text(2)
	prompt_ui_state = e_prompt_ui_state.RESULT
	if(prompt_array):
		GlobalData.prompt_array_storage.append(prompt_array[1])
		GlobalData.prompt_array_storage.append(prompt_array[2])
		GlobalData.prompt_array_storage.append("\n")
		prompt_array = null
		
	
func update_text(i):
	timer.start()
	if(prompt_array):
		label.text = prompt_array[i]


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shrink_textbox":
		prompt_box.visible = false
		prompt_ui_state = e_prompt_ui_state.HIDDEN
