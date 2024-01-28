extends Node2D

var AssetPaths = ["res://assets/sprites/DeskPic.png","res://assets/sprites/DeskNotes.png","res://assets/sprites/DeskClock.png"]
var rng = RandomNumberGenerator.new()
@export var _LayerSpeed = 0.5
@onready var _Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Assign Random Texture
	assignRandomTexture()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Sprite2D.position.x -= _LayerSpeed * GlobalData.world_speed
	
	checkOffScreen()
	
	pass
	
func checkOffScreen():
	if ($Sprite2D.position.x <= -600):
		self.queue_free()
		print("Destroying self")
	pass
	
# Helper fuction to assign the Sprite2D's Texture
func assignRandomTexture():
	
	var _Rand = rng.randi_range(0,AssetPaths.size() - 1)
	
	_Sprite2D.texture = load(AssetPaths[_Rand])
	
	pass
