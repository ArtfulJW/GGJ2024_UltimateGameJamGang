extends CanvasLayer

@export var prompt_gen : Node2D
@onready var animation_player = $AnimationPlayer
@onready var label = $Control/NinePatchRect/ColorRect/Label

var start_text 
var prompt_array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	GlobalData.thought_collide_bad.connect(update_text_result)
	GlobalData.restart.connect(reset_text)
	start_text = label.text
	
func _on_timer_timeout():
	animation_player.play("shrink_textbox")

func reset_text():
	label.text = start_text
	
func update_text_prompt():
	prompt_array = prompt_gen.prompt_generate_random(prompt_gen.e_prompt_type.NEGATIVE_MINOR)
	update_text(1)

func update_text_result():
	update_text(2)
	
func update_text(i):
	if(prompt_array):
		label.text = prompt_array[i]

	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shrink_textbox":
		update_text_prompt() # Replace with function body.
		animation_player.play("grow_textbox")
