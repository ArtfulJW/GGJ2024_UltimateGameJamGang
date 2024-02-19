extends Node2D

@onready var player = $Player
@onready var start_pos = player.position
@onready var start_screen = $StartScreen_CanvasLayer



func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	

	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	# debug input:
	
	#if event.is_action_pressed("game_reset"):
		#reset()
		#start_screen.visible = true
	#if event.is_action_pressed("cheat"):
		#GlobalData.score_good = 10
		#player.x_dest = -10
		

func reset():
	player.x_dest = start_pos.x
	player.reset()
	
	GlobalData.world_speed = GlobalData.world_speed_start
	GlobalData.prompt_array_storage.clear()
	GlobalData.score_good = 0
	GlobalData.score_bad = 0
	GlobalData.restart.emit()
	

