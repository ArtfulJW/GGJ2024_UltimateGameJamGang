extends CanvasLayer
@onready var reset_timer = $ResetTimer
@export var main : Node2D

var _IsInstructionsScreenVisible = false
var _IsCreditScreenVisible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	GlobalData.continue_from_progress.connect(handle_restart)

func _on_button_pressed():
	get_tree().paused = false
	visible = false

func handle_restart():
	visible = true
	main.reset()



func _on_button_2_button_down():
	_IsInstructionsScreenVisible = true
	$Control/InstructionScreen.visible = _IsCreditScreenVisible
	pass # Replace with function body.


func _on_button_3_button_down():
	_IsCreditScreenVisible = true
	$Control/CreditScreen.visible = _IsCreditScreenVisible
	pass # Replace with function body.
