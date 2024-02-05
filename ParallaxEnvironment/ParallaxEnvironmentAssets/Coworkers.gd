extends Node2D

var AssetPaths = ["res://assets/sprites/Sprites/MuscleDaddy.png","res://assets/sprites/Sprites/LeanRizzer.png","res://assets/sprites/Sprites/CynicalGirl.png"]
var rng = RandomNumberGenerator.new()

@export var _LayerSpeed = 0.6
@onready var _Sprite2D = $Sprite2D
@onready var _AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	assignRandomTexture()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$AnimatedSprite2D.position.x -= _LayerSpeed * GlobalData.world_speed
	
	checkOffScreen()
	
	pass
	
func checkOffScreen():
	if ($AnimatedSprite2D.position.x <= -600):
		self.queue_free()
		#print("Destroying self")
	pass	

# Helper fuction to assign the Sprite2D's Texture
func assignRandomTexture():
	
	var _Rand = rng.randi_range(1,4)
	
	match _Rand:
		1:
			_AnimatedSprite2D.play("Boss_Final")
			pass
		2:
			_AnimatedSprite2D.play("CynicalGirl_Final")
			pass
		3:
			_AnimatedSprite2D.play("LoveInterest_Final")
			pass
		4:
			_AnimatedSprite2D.play("RizzMan_Final")
			pass
	
	#_Sprite2D.texture = load(AssetPaths[_Rand])
	
	pass
