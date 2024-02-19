extends Node2D

var AssetPaths = ["res://assets/sprites/Wall/Certificates.png", "res://assets/sprites/Wall/Notices.png", "res://assets/sprites/Wall/Paintings.png","res://assets/sprites/Wall/Whiteboard.png","res://assets/sprites/Wall/Windowframe.png","res://assets/sprites/Wall/Windowframe.png","res://assets/sprites/Wall/Windowframe.png"]

@export var _LayerSpeed = 0.25
@onready var _Sprite2D = $Sprite2D

var _EndTime = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_EndTime = Time.get_unix_time_from_system()
	
	assignRandomTexture(_EndTime - GlobalData._StartTime)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Sprite2D.position.x -= _LayerSpeed * GlobalData.world_speed  * delta * GlobalData.parallax_scaler
	
	checkOffScreen()
	
	pass
	
# Helper fuction to assign the Sprite2D's Texture
func assignRandomTexture(_ElapsedTime):
	
	var _Rand = rng.randi_range(0,AssetPaths.size() - 1)
	
	if _ElapsedTime <= 3:
		_Rand = rng.randi_range(0,2)
		_Sprite2D.texture = load(AssetPaths[_Rand])
	else:
		_Sprite2D.texture = load(AssetPaths[_Rand])
		
	#print("_Rand:" + str(_Rand))
	#print("_ElapsedTime:" + str(_ElapsedTime))
	pass

func checkOffScreen():
	if ($Sprite2D.position.x <= -600):
		self.queue_free()
		#print("Destroying self")
	pass
