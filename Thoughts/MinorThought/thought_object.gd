extends Area2D

@onready var cloud_animation = $CloudAnimation
@onready var collision_shape_2d = $CollisionShape2D
@onready var lightning_bottle = $Lightning_bottle

var speed = 80
var is_collided = false
var is_passed = false
var player
var is_good = randi_range(0,5) == 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pick_visuals()
	Wwise.register_game_obj(self, self.name)
	

func set_player(new_player):
	player = new_player

func pick_visuals():
	var random_value = randi_range(0,2)
	if (random_value == 0):
		cloud_animation.play("cloud_1")
	elif random_value == 1:
		cloud_animation.play("cloud_2")
	else:
		cloud_animation.play("cloud_3")
	
	if is_good:
		cloud_animation.modulate = Color.AQUA
		lightning_bottle.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta * GlobalData.world_speed
	
	if not is_passed and not is_collided and position.x < player.position.x:
		is_passed = true
		if not is_good:
			GlobalData.thought_passed_player.emit()
			GlobalData.world_speed += GlobalData.world_delta
		
	if position.x < -32:
		if (!is_collided):
			GlobalData.thought_despawn.emit()
		queue_free()


func _on_body_entered(body):
	if (!is_collided and body.name == "Player"):
		is_collided = true
		cloud_animation.play("pop")
		collision_shape_2d.disabled = true
		if not is_good:
			body.on_collision()
			Wwise.set_2d_position(self, get_global_transform(), 0)
			Wwise.post_event_id(AK.EVENTS.SFX_CLOUDIMPACT_BAD, self)
		else:
			body.on_thought_passed()
			Wwise.set_2d_position(self, get_global_transform(), 0)
			Wwise.post_event_id(AK.EVENTS.SFX_CLOUDIMPACT_GOOD, self)
		
func _on_cloud_animation_animation_looped():
	if is_collided:
		cloud_animation.stop()
		queue_free()
		


