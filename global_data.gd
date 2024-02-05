extends Node

var world_speed_start = 2
var world_speed = world_speed_start
var world_delta = 0.025

var score_good = 0
var score_bad = 0
var progress = 0
var max_progress = 10
var positive_progress_score_threshold = 15

var tile_size = 20

var _StartTime = Time.get_unix_time_from_system()

var screen_size_x = ProjectSettings.get_setting("display/window/size/viewport_width") 
var screen_size_y = ProjectSettings.get_setting("display/window/size/viewport_height") 

signal thought_passed_player
signal thought_collide_good
signal thought_collide_bad
signal thought_despawn_good
signal thought_despawn_bad
signal restart
signal player_died
signal continue_from_progress
