extends Node2D

@onready var spawn_timer = $SpawnTimer

var spawn_point = Vector2.ZERO
var thought_prefab = preload("res://Thoughts/thought_object.tscn")
var thought_size = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	handle_spawn()
	spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_timer.time_left <= 0:
		handle_spawn()

func handle_spawn():
	spawn_point.x = GlobalData.screen_size_x + thought_size
	spawn_point.y = randf_range(GlobalData.screen_size_y / 2 + thought_size, GlobalData.screen_size_y)
	var new_thought = thought_prefab.instantiate()
	new_thought.position = spawn_point
	add_child(new_thought)
	spawn_timer.start()
