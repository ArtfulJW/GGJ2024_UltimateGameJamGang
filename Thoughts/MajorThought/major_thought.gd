extends Area2D

@export var x_wiggle : float = 1
@export var x_range : float = 7
@export var wiggle_salt : float = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += sin(x_wiggle) * x_range * delta
	x_wiggle += wiggle_salt * delta
