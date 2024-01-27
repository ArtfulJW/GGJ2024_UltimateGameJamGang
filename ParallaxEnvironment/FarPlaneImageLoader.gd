extends Sprite2D

@export var _ImagePath: String = ""
# @onready var _FarPlane = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(_ImagePath)

	get_node("/root/ParallaxEnvironment/Sprite2D").texture = load("res://Screens/bg_tmp.png")
	#_FarPlane.texture = load("res://Screens/bg_tmp.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
