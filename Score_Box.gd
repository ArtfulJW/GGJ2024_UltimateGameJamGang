extends Control
@onready var label_bad = $Label_bad
@onready var label_good = $Label_good


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_bad.text = "x " + str(GlobalData.score_bad)
	label_good.text = "x " + str(GlobalData.score_good)
