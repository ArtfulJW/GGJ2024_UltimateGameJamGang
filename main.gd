extends Node2D

@onready var player = $Player
@onready var start_pos = player.position

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

func _input(event):
	if event.is_action_pressed("game_reset"):
		reset()
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		

func reset():
	player.x_dest = start_pos.x
	GlobalData.world_speed = 1
