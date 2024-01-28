extends CanvasLayer

@export var prompt_gen : Node2D
@onready var label = $Control/NinePatchRect/Label
@onready var start_text = label.text
var prompt_array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	GlobalData.thought_collide_bad.connect(update_text_result)
	GlobalData.restart.connect(reset_text)
	
func _on_timer_timeout():
	update_text_prompt()

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

	
