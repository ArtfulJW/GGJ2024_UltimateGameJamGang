extends Area2D

@onready var cloud_animation = $CloudAnimation
@onready var collision_shape_2d = $CollisionShape2D

var speed = 80
var is_collided = false
var is_passed = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_value = randi_range(0,2)
	if (random_value == 0):
		cloud_animation.play("cloud_1")
	elif random_value == 1:
		cloud_animation.play("cloud_2")
	else:
		cloud_animation.play("cloud_3")

func set_player(new_player):
	player = new_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta * GlobalData.world_speed
	
	if not is_passed and not is_collided and position.x < player.position.x:
		GlobalData.thought_passed_player.emit()
		GlobalData.world_speed += GlobalData.world_delta
		is_passed = true
		
	if position.x < -32:
		if (!is_collided):
			GlobalData.thought_despawn.emit()
		queue_free()


func _on_body_entered(body):
	if (!is_collided and body.name == "Player"):
		body.on_collision()
		is_collided = true
		cloud_animation.play("pop")
		collision_shape_2d.disabled = true
		
		
func _on_cloud_animation_animation_finished():
	if is_collided:
		cloud_animation.stop()
		queue_free()
