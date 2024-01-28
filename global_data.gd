extends Node

var world_speed_start = 2
var world_speed = world_speed_start
var world_delta = 0.025

var tile_size = 20

var screen_size_x = ProjectSettings.get_setting("display/window/size/viewport_width") 
var screen_size_y = ProjectSettings.get_setting("display/window/size/viewport_height") 

signal thought_passed_player
signal thought_despawn
signal player_died
