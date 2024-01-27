extends Node2D

# Hard Code Starting Wall
@export var _StartingWall = "res://ParallaxEnvironment/ParallaxEnvironmentAssets/StartWall.tscn"

@export var _DeskAssetPath = ""
@export var _WindowAssetPath = ""
@export var _CityScapeAssetPath = ""

@onready var _FirstLayerSpawnPoint = $FirstLayerSP
@onready var _SecondLayerSpawnPoint = $SecondLayerSP
@onready var _ThirdLayerSpawnPoint = $ThirdLayerSP

@onready var _FirstLayerTimer = $Timer
@onready var _SecondLayerTimer = $Timer2
@onready var _ThirdLayerTimer = $Timer3

var _ElapsedTotalTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	SetTimerAutoStart(true)
	StartTimers()
	
	spawnAsset(_StartingWall,2)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	pass
	
	
# Helper function to spawn asset
func spawnAsset(_AssetPath, _Layer):
	var _SpawnedAsset = load(_AssetPath).instantiate()
	
	match _Layer:
		1:
			#print("Set position to: " + _FirstLayerSpawnPoint.position.x)
			_SpawnedAsset.position = _FirstLayerSpawnPoint.position
			pass
		2:
			#print("Set position to: " + _SecondLayerSpawnPoint.position.x)
			_SpawnedAsset.position = _SecondLayerSpawnPoint.position
			pass
		3:
			#print("Set position to: " + _ThirdLayerSpawnPoint.position.x)
			_SpawnedAsset.position = _ThirdLayerSpawnPoint.position
			pass
	
	add_child(_SpawnedAsset)

# Helper Function to start all the timers
func startTimers():
	_FirstLayerTimer.start()
	_SecondLayerTimer.start()
	_ThirdLayerTimer.start()

func _on_timer_timeout():
	spawnAsset(_DeskAssetPath,1)
	pass # Replace with function body.


func _on_timer_2_timeout():
	spawnAsset(_WindowAssetPath,2)
	pass # Replace with function body.


func _on_timer_3_timeout():
	spawnAsset(_CityScapeAssetPath,3)
	pass # Replace with function body.
	
# Helper function to set autostart for all timersf
func SetTimerAutoStart(_InputBoolean):
	_FirstLayerTimer.autostart = _InputBoolean
	_SecondLayerTimer.autostart = _InputBoolean
	_ThirdLayerTimer.autostart = _InputBoolean
	
	# Helper function to set start for all timersf
func StartTimers():
	_FirstLayerTimer.start()
	_SecondLayerTimer.start()
	_ThirdLayerTimer.start()

