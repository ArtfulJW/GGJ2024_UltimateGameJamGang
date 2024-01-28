extends Node2D

@export var _LayerSpeed = 0.125

# Called when the node enters the scene tree for the first time.
func _ready():
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