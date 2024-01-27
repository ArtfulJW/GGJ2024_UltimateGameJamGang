extends Area2D

var sprite_2d
var speed = 80
var is_collided = false
var is_passed = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_value = randi() % 3 + 1
	if (random_value == 1):
		sprite_2d=$Cloud1Animation
	elif random_value == 2:
		sprite_2d=$Cloud2Animation
	else:
		sprite_2d=$Cloud3Animation

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
	sprite_2d.modulate = Color.AQUA
	
	if (!is_collided and body.name == "Player"):
		body.on_collision()
		GlobalData.world_speed -= GlobalData.world_delta
		
	is_collided = true
