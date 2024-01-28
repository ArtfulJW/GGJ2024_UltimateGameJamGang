extends Node2D
@export var children : Array[Node2D]


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in children:
		child.visible = not randi_range(0,2) == 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
