extends CanvasLayer

@onready var reset_timer = $ResetTimer
@onready var intro_beat = $intro_beat
@onready var credits = $credits
@onready var instructions = $instructions
@onready var close_button = $Close_button
@onready var credit_scroll = $credits/CreditScroll

@export var main : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	GlobalData.continue_from_progress.connect(handle_restart)

func _on_start_button_pressed():
	if intro_beat.visible == false:
		intro_beat.visible = true
		return
	
	get_tree().paused = false
	visible = false

func handle_restart():
	visible = true
	main.reset()

func _on_credits_button_pressed():
	credit_scroll.play("credits")
	credits.visible = true
	instructions.visible = false 
	close_button.visible = true

func _on_instructions_button_pressed():
	credits.visible = false
	instructions.visible = true
	close_button.visible = true


func _on_close_button_pressed():
	credits.visible = false
	instructions.visible = false
	close_button.visible = false
