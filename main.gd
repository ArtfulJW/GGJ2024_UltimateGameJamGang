extends Node2D

@onready var player = $Player
@onready var start_pos = player.position

# The arrays which will hold all the prompts and other data
var prompts_negative_minor_array: 	Array = []
var prompts_negative_major_array: 	Array = []
var prompts_positive_minor_array: 	Array = []
var prompts_noun_array: 			Array = []
var prompts_verb_array: 			Array = []



func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	## Import CSV and parse data
	prompts_import_data();

func _input(event):
	if event.is_action_pressed("game_reset"):
		reset()
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		

func reset():
	player.x_dest = start_pos.x
	GlobalData.world_speed = 1

func prompts_import_data():
	
	
	
	
	## ----------------------- Get all data from files
	
	# Minor Negative Thoughts
	var _file_negative_minor = FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Minor Negative Prompts.csv", FileAccess.READ)
	while !_file_negative_minor.eof_reached():
		## get row
		var _csv_row = Array(_file_negative_minor.get_csv_line())
		prompts_negative_minor_array.append(_csv_row);
	_file_negative_minor.close()
	prompts_negative_minor_array.pop_back(); 	#remove last empty array get_csv_line() has created 
	prompts_negative_minor_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Major Negative thoughts
	var _file_negative_major 	= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Major Negative Prompts.csv", FileAccess.READ)
	while !_file_negative_major.eof_reached():
		## get row
		var _csv_row = Array(_file_negative_major.get_csv_line())
		prompts_negative_major_array.append(_csv_row);
	_file_negative_major.close()
	prompts_negative_major_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_negative_major_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Minor Positive thoughts
	var _file_positive_minor 	= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Minor Positive Prompts.csv", FileAccess.READ)
	while !_file_positive_minor.eof_reached():
		## get row
		var _csv_row = Array(_file_positive_minor.get_csv_line())
		prompts_positive_minor_array.append(_csv_row);
	_file_positive_minor.close()
	prompts_positive_minor_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_positive_minor_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Nouns
	var _file_nouns 			= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Nouns.csv", FileAccess.READ)
	while !_file_nouns.eof_reached():
		## get row
		var _csv_row = Array(_file_nouns.get_csv_line())
		prompts_noun_array.append(_csv_row);
	_file_nouns.close()
	prompts_noun_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_noun_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Verbs
	var _file_verbs 			= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Verbs.csv", FileAccess.READ)
	while !_file_verbs.eof_reached():
		## get row
		var _csv_row = Array(_file_verbs.get_csv_line())
		prompts_verb_array.append(_csv_row);
	_file_verbs.close()
	prompts_verb_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_verb_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	
	
	
	
