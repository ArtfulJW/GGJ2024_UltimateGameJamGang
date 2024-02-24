extends Control
@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var text_cycle_timer = $text_cycle_timer
@onready var restart_timer = $restart_timer

func _ready():
	start_animation_sequence()



func _on_text_cycle_timer_timeout():
	animation_player.speed_scale = 1
	animation_player.play("prompt_box_ui_text_transition")
		
	text_cycle_timer.start()

func cycle_text():
	label.text = "Run, red stapler, run!"

func start_animation_sequence():
	animation_player.speed_scale = 2
	animation_player.play("prompt_box_ui_cloud_animation")
	label.text = "There's a red stapler here, minding its own business."
	restart_timer.start()


func _on_restart_timer_timeout():
	start_animation_sequence()
