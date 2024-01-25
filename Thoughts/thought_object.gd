extends Area2D

@onready var sprite_2d = $Sprite2D
var speed = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta * GlobalData.world_speed
	if position.x < -32:
		GlobalData.world_speed += 0.1
		queue_free()




func _on_body_entered(body):
	print("collision!")
	sprite_2d.modulate = Color.AQUA
