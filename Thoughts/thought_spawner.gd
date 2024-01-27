extends Node2D

@onready var spawn_timer = $SpawnTimer
@export var player: Node
@export var MIN_SPAWN_TIME: float = 1

var spawn_point = Vector2.ZERO
var thought_prefab = preload("res://Thoughts/MinorThought/thought_object.tscn")
var thought_size = 16
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
	spawn_point.x = GlobalData.screen_size_x + thought_size
	spawn_point.y = randf_range(GlobalData.screen_size_y / 2 + thought_size, GlobalData.screen_size_y)
	var new_thought = thought_prefab.instantiate()
	new_thought.set_player(player)
	new_thought.position = spawn_point
	add_child(new_thought)
	
	if(spawn_timer.wait_time >= MIN_SPAWN_TIME):
		spawn_timer.wait_time = spawn_time / GlobalData.world_speed
	else:
		spawn_timer.wait_time = MIN_SPAWN_TIME
		
	spawn_timer.start()
