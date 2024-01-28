extends Node2D

# Hard Code Starting Wall
@export var _StartingWall = "res://ParallaxEnvironment/ParallaxEnvironmentAssets/StartWall.tscn"

@export var _DeskAssetPath = ""
@export var _WindowAssetPath = ""
@export var _CityScapeAssetPath = ""
@export var _ForegroundAssetPath = ""
@export var _CoworkerAssetPath = "res://ParallaxEnvironment/ParallaxEnvironmentAssets/Coworkers.tscn"

@export var _ForegroundTimerLowerRange = 2.0
@export var _ForegroundTimerHigherRange = 5.0

@onready var _FirstLayerSpawnPoint = $FirstLayerSP
@onready var _SecondLayerSpawnPoint = $SecondLayerSP
@onready var _ThirdLayerSpawnPoint = $ThirdLayerSP
@onready var _FourthLayerSpawnPoint = $FourthLayerSP
@onready var _CoworkersSpawnPoint = $CoworkerSP

@onready var _FirstLayerTimer = $Timer
@onready var _SecondLayerTimer = $Timer2
@onready var _ThirdLayerTimer = $Timer3
@onready var _FourthLayerTimer = $Timer4
@onready var _CoworkerTimer = $CoworkerTimer

var _ElapsedTotalTime = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	SetTimerAutoStart(true)
	StartTimers()
	
	spawnAsset(_StartingWall,2)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	checkWorldSpeed()
	
	#print(GlobalData.world_speed)
	
	pass
	
	
# Helper function to spawn asset
func spawnAsset(_AssetPath, _Layer):
	var _SpawnedAsset = load(_AssetPath).instantiate()
	
	match _Layer:
		1:
			# City Skyline
			_SpawnedAsset.position = _FirstLayerSpawnPoint.position
			pass
		2:
			# Windows
			_SpawnedAsset.position = _SecondLayerSpawnPoint.position
			pass
		3:
			# Desks
			_SpawnedAsset.position = _ThirdLayerSpawnPoint.position
			pass
		4:
			# Foreground Spawning
			_SpawnedAsset.position = _FourthLayerSpawnPoint.position
			pass
		5: 
			_SpawnedAsset.position = _CoworkersSpawnPoint.position
			pass
	
	add_child(_SpawnedAsset)

# Helper Function to start all the timers
func startTimers():
	_FirstLayerTimer.start()
	_SecondLayerTimer.start()
	_ThirdLayerTimer.start()
	_CoworkerTimer.start()

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
	_FourthLayerTimer.autostart = _InputBoolean
	_CoworkerTimer.autostart = _InputBoolean
	pass
	
# Helper function to set start for all timersf
func StartTimers():
	_FirstLayerTimer.start(2)
	_SecondLayerTimer.start(2.5)
	_ThirdLayerTimer.start(2)
	_FourthLayerTimer.start(2)
	_CoworkerTimer.start(4)
	pass

func checkWorldSpeed():
	_FirstLayerTimer.wait_time = 2 / GlobalData.world_speed
	_SecondLayerTimer.wait_time = 2.5 / GlobalData.world_speed
	_ThirdLayerTimer.wait_time = 2 / GlobalData.world_speed
	_CoworkerTimer.wait_time = 4 / GlobalData.world_speed
	pass

"""
Foreground Timer - 
1. Each Timeout, assign a random wait_time
"""
func _on_timer_4_timeout():
	
	spawnAsset(_ForegroundAssetPath,4)
	
	# Generate random number to vary spawning
	var _Rand = rng.randf_range(3,5)
	_FourthLayerTimer.wait_time = _Rand
	
	pass 


func _on_coworker_timer_timeout():
	spawnAsset(_CoworkerAssetPath,5)
	
		# Generate random number to vary spawning
	var _Rand = rng.randf_range(_ForegroundTimerLowerRange,_ForegroundTimerHigherRange)
	_CoworkerTimer.wait_time = _Rand
	
	pass # Replace with function body.
