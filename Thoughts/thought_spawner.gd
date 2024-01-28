extends Node2D

@onready var spawn_timer = $SpawnTimer
@export var player: Node
@export var MIN_SPAWN_TIME: float = 1

var spawn_point = Vector2.ZERO
var thought_prefab = preload("res://Thoughts/MinorThought/thought_object.tscn")
var thought_size = GlobalData.tile_size # 16
var spawn_time



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_time = spawn_timer.wait_time
	spawn_timer.start()
	handle_spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_timer.time_left <= 0:
		handle_spawn()

func handle_spawn():
	
	# Spawn thoughts on the right side of the screen
	# They will spawn at specific y positons, to either walk under, slide under, or jump over
	spawn_point.x = GlobalData.screen_size_x + thought_size * 1.5
	spawn_point.y = GlobalData.screen_size_y - randi_range(1, 3) * GlobalData.tile_size - (GlobalData.tile_size/1.5)		# From floor to 0-2 tiles above floor
	
	# Creates new thought bubble
	var new_thought = thought_prefab.instantiate()
	new_thought.set_player(player)
	new_thought.position = spawn_point
	add_child(new_thought)
	
	# Set spawn time for more thoughts based on world speed
	spawn_timer.wait_time = max(MIN_SPAWN_TIME, spawn_time / GlobalData.world_speed)
	
	# restart timer for next thought bubble
	spawn_timer.start()
