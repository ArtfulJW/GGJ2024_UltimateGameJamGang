extends Control

@onready var fader = $Fader
@onready var animation_player = $"AnimationPlayer"

signal on_fade_out_complete


func start_fade_in():
	fader.visible = true
	animation_player.play("fade_in")

func start_fade_out():
	fader.visible = true
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	fader.visible = false 
	fader.color.a = 0
	animation_player.stop()
	on_fade_out_complete.emit()
