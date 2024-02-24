extends Area2D

@onready var cloud_animation = $CloudAnimation
@onready var collision_shape_2d = $CollisionShape2D
@onready var lightning_bottle = $LightningBottle

var speed_max 		= 1.5
var speed 			= 0.50			#Initial speed for players to see it coming
var speed_accel 	= 0.25/60.0		# gradually increase speed
var is_collided = false
var is_passed = false
var player
var is_good = randi_range(0,5) == 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pick_visuals()
	Wwise.register_game_obj(self, self.name)
	
	GlobalData.restart.connect(_on_game_restart)


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
	
	var delta_normal = delta / (1.0/60.0)
	
	# Increase speed, but only once I passed a certain point to give player a chance
	# to see I'm coming towards them
	# alsp speed up gradually over time to better alert player
	if position.x <= GlobalData.screen_size_x - (GlobalData.tile_size * 1):
		speed = min(speed_max, speed + (speed_accel * delta_normal * GlobalData.world_speed))
	
	# update position, move left
	position.x -= speed * delta_normal * GlobalData.world_speed
	
	if not is_passed and not is_collided and position.x < player.position.x:
		is_passed = true
		if not is_good:
			GlobalData.thought_passed_player.emit()
			GlobalData.world_speed += GlobalData.world_delta
		
	if position.x < -32:
		if (!is_collided):
			if is_good:
				GlobalData.thought_despawn_good.emit()
			else:
				GlobalData.thought_despawn_bad.emit()
		queue_free()

func _on_game_restart():
	queue_free();
	pass
	
func _on_body_entered(body):
	if (!is_collided and body.name == "Player"):
		is_collided = true
		cloud_animation.play("pop")
		collision_shape_2d.set_deferred("disabled",true)
		if not is_good:
			body.on_collision()
			GlobalData.thought_collide_bad.emit()
			GlobalData.score_bad += 1
			Wwise.set_2d_position(self, get_global_transform(), 0)
			Wwise.post_event_id(AK.EVENTS.SFX_CLOUDIMPACT_BAD, self)
		else:
			body.on_thought_passed()
			GlobalData.thought_collide_good.emit()
			GlobalData.score_good += 1
			Wwise.set_2d_position(self, get_global_transform(), 0)
			Wwise.post_event_id(AK.EVENTS.SFX_CLOUDIMPACT_GOOD, self)
		
func _on_cloud_animation_animation_finished():
	if is_collided:
		cloud_animation.stop()
		queue_free()
		


