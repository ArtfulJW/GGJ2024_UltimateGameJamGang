extends Node

var world_speed = 1
var world_delta = 0.1

var _StartTime = Time.get_unix_time_from_system()

var screen_size_x = ProjectSettings.get_setting("display/window/size/viewport_width") 
var screen_size_y = ProjectSettings.get_setting("display/window/size/viewport_height") 

signal thought_passed_player
signal thought_despawn
signal player_died
