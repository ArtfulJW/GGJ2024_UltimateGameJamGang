extends Node2D

@onready var player = $Player
@onready var start_pos = player.position
@onready var start_screen = $StartScreen_CanvasLayer

# The arrays which will hold all the prompts and other data
var prompts_negative_minor_array: 	Array = []
var prompts_negative_major_array: 	Array = []
var prompts_positive_minor_array: 	Array = []
var prompts_noun_array: 			Array = []
var prompts_verb_array: 			Array = []

# Prompts that get collected and shown at the end of the run
var prompts_negative_collected:		Array = []
var prompts_positive_collected:		Array = []

enum e_prompt_param {
	PROP_ID,			# ID for the prop, if any. "" if empty, an an Array of prop ID's if it has a prop or more
	DIALOGUE_START,		# Starting index of the prompt. # of dialogues can be 1 or many. To get total prompt entries, get size of the prompt array subtracting this value
	
	length
}

enum e_fill_in_word_param {
	PROP_ID,			# The prop it's tied to, if any. "" otherwise. 
	WORD,				# The word to replace in the prompt
	
	length
}

enum e_prompt_type {
	NEGATIVE_MINOR,
	NEGATIVE_MAJOR,
	POSITIVE_MINOR,
	
	length
}

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	## Import CSV and parse data
	prompts_import_data();
	
	
	
	## --------------- Debug test generate prompt
	
	# Generate Prompt
	var _prompt = prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)
	print(_prompt)
	
	# Display all dialogue boxes for prompt. 
	for _d in _prompt.size() - e_prompt_param.DIALOGUE_START:
		
		# Get each piece of dialogue in the prompt
		var _dialogue_id = e_prompt_param.DIALOGUE_START + _d
		
		# Do something with the dialogue
		print(_prompt[_dialogue_id])
	
	# Spawn all the props
	for _p in _prompt[e_prompt_param.PROP_ID].size():
		# There may be multiple props
		var _prop = _prompt[e_prompt_param.PROP_ID][_p];
		
		# Spawn props, do something
		if _prop != "":
			print("spawning prop: " + str(_prop))
	
	## -----------------------------------------------
	
	
	
	
	#print("Minor Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)))
	#print("Minor Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)))
	#print("Minor Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)))
	#print("Minor Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)))
	#print("Minor Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MINOR)))
	#print("")
	#print("Minor Positive prompt: " + str(prompt_generate_random(e_prompt_type.POSITIVE_MINOR)))
	#print("Minor Positive prompt: " + str(prompt_generate_random(e_prompt_type.POSITIVE_MINOR)))
	#print("Minor Positive prompt: " + str(prompt_generate_random(e_prompt_type.POSITIVE_MINOR)))
	#print("Minor Positive prompt: " + str(prompt_generate_random(e_prompt_type.POSITIVE_MINOR)))
	#print("Minor Positive prompt: " + str(prompt_generate_random(e_prompt_type.POSITIVE_MINOR)))
	#print("")
	#print("Major Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MAJOR)))
	#print("Major Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MAJOR)))
	#print("Major Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MAJOR)))
	#print("Major Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MAJOR)))
	#print("Major Negative prompt: " + str(prompt_generate_random(e_prompt_type.NEGATIVE_MAJOR)))
	
	

func _input(event):
	if event.is_action_pressed("game_reset"):
		reset()
		start_screen.visible = true
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		

func reset():
	player.x_dest = start_pos.x
	player.reset()
	
	if(GlobalData.score_good >= GlobalData.positive_progress_score_threshold):
		GlobalData.progress += 1
	
	GlobalData.world_speed = GlobalData.world_speed_start
	GlobalData.score_good = 0
	GlobalData.score_bad = 0
	GlobalData.restart.emit()
	

func prompts_import_data():
	
	
	
	
	## ----------------------- Get all data from files
	
	# Minor Negative Thoughts
	var _file_negative_minor = FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Minor Negative Prompts.csv", FileAccess.READ)
	while !_file_negative_minor.eof_reached():
		## get row
		var _csv_row = Array(_file_negative_minor.get_csv_line())
		prompts_negative_minor_array.append(_csv_row);
	_file_negative_minor.close()
	#prompts_negative_minor_array.pop_back(); 	#remove last empty array get_csv_line() has created 
	prompts_negative_minor_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Major Negative thoughts
	var _file_negative_major 	= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Major Negative Prompts.csv", FileAccess.READ)
	while !_file_negative_major.eof_reached():
		## get row
		var _csv_row = Array(_file_negative_major.get_csv_line())
		prompts_negative_major_array.append(_csv_row);
	_file_negative_major.close()
	#prompts_negative_major_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_negative_major_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Minor Positive thoughts
	var _file_positive_minor 	= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Minor Positive Prompts.csv", FileAccess.READ)
	while !_file_positive_minor.eof_reached():
		## get row
		var _csv_row = Array(_file_positive_minor.get_csv_line())
		prompts_positive_minor_array.append(_csv_row);
	_file_positive_minor.close()
	#prompts_positive_minor_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_positive_minor_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Nouns
	var _file_nouns 			= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Nouns.csv", FileAccess.READ)
	while !_file_nouns.eof_reached():
		## get row
		var _csv_row = Array(_file_nouns.get_csv_line())
		prompts_noun_array.append(_csv_row);
	_file_nouns.close()
	#prompts_noun_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_noun_array.pop_front() # remove first array (_headers) from the _csv, put into separate data
	
	# Verbs
	var _file_verbs 			= FileAccess.open("res://CSV/Game Jam Sheets - Thot Jot - Verbs.csv", FileAccess.READ)
	while !_file_verbs.eof_reached():
		## get row
		var _csv_row = Array(_file_verbs.get_csv_line())
		prompts_verb_array.append(_csv_row);
	_file_verbs.close()
	#prompts_verb_array.pop_back(); #remove last empty array get_csv_line() has created 
	prompts_verb_array.pop_front() # remove first array (_headers) from the _csv, put into separate data

func prompt_generate_random(_e_prompt_type):
	
	# Generates a random prompt
	# returns an array with the data for the prompt as dictated in the enum e_prompt_param
	
	var _random_prompt_array: Array;	# The prompt array we will return
	
	var _prompt_list_to_choose;		# Which list gets chosen -- positive, negative, etc
	var _prompt_id;					# Prompt id to choose from list
	var _noun_total = 0;			# Total nouns in the prompt
	var _nouns: Array = [];				# Chosen nouns for the prompt
	var _verb_total = 0;			# Total verbs in the prompt
	var _verbs: Array = [];				# Chosen verbs for the prompt
	
	var _rng = RandomNumberGenerator.new()
	
	
	
	# Choose a random prompt
	var _num_prompts;
	match _e_prompt_type:
		e_prompt_type.NEGATIVE_MINOR:
			_prompt_list_to_choose = prompts_negative_minor_array
		e_prompt_type.NEGATIVE_MAJOR:
			_prompt_list_to_choose = prompts_negative_major_array
		e_prompt_type.POSITIVE_MINOR:
			_prompt_list_to_choose = prompts_positive_minor_array
	
	_num_prompts 			= _prompt_list_to_choose.size();
	_prompt_id 				= _rng.randi_range(0, _num_prompts-1)
	_random_prompt_array 	= Array(_prompt_list_to_choose[_prompt_id]).duplicate(true)
	
	# Clear empty dialogues from prompt
	while _random_prompt_array[_random_prompt_array.size()-1] == "":
		_random_prompt_array.pop_back();
	
	# Set props as array
	if "" in _random_prompt_array[e_prompt_param.PROP_ID]: 
		_random_prompt_array[e_prompt_param.PROP_ID] = []
	else:
		var _new_array: Array = []
		_new_array.append(_random_prompt_array[e_prompt_param.PROP_ID])
		_random_prompt_array[e_prompt_param.PROP_ID] = _new_array
	
	
	
	# count total words of each type to use
	for _pd in _random_prompt_array.size()-e_prompt_param.DIALOGUE_START:
		var _prompt_dialogue = _random_prompt_array[e_prompt_param.DIALOGUE_START + _pd]
		
		if "{0n}" in _prompt_dialogue and _noun_total <= 0: _noun_total = 1;
		if "{1n}" in _prompt_dialogue and _noun_total <= 1: _noun_total = 2;
		if "{2n}" in _prompt_dialogue and _noun_total <= 2: _noun_total = 3;
		if "{3n}" in _prompt_dialogue and _noun_total <= 3: _noun_total = 4;
		if "{4n}" in _prompt_dialogue and _noun_total <= 4: _noun_total = 5;
		if "{5n}" in _prompt_dialogue and _noun_total <= 5: _noun_total = 6;
		
		if "{0v}" in _prompt_dialogue and _verb_total <= 0: _verb_total = 1;
		if "{1v}" in _prompt_dialogue and _verb_total <= 1: _verb_total = 2;
		if "{2v}" in _prompt_dialogue and _verb_total <= 2: _verb_total = 3;
		if "{3v}" in _prompt_dialogue and _verb_total <= 3: _verb_total = 4;
		if "{4v}" in _prompt_dialogue and _verb_total <= 4: _verb_total = 5;
		if "{5v}" in _prompt_dialogue and _verb_total <= 5: _verb_total = 6;
			
	
	# Choose random verbs and nouns
	# also add any associated props to the array
	var _num_nouns = prompts_noun_array.size();
	var _num_verbs = prompts_verb_array.size();
	for _n in _noun_total:
		_nouns.append(prompts_noun_array[_rng.randi_range(0, _num_nouns-1)].duplicate(true))
		
		var _word_prop_id = _nouns[_n][e_prompt_param.PROP_ID]
		if _word_prop_id != "": _random_prompt_array[e_prompt_param.PROP_ID].append(_word_prop_id) 
	for _v in _verb_total:
		_verbs.append(prompts_verb_array[_rng.randi_range(0, _num_verbs-1)].duplicate(true))
		
		var _word_prop_id = _verbs[_v][e_prompt_param.PROP_ID]
		if _word_prop_id != "": _random_prompt_array[e_prompt_param.PROP_ID].append(_word_prop_id) 
		
		#print("Nouns: " + str(_nouns))
		#print("Verbs: " + str(_verbs))
	
	# replace code identifiers in prompt with words
	for _pd in _random_prompt_array.size()-e_prompt_param.DIALOGUE_START:
		#var _prompt_dialogue = _random_prompt_array[e_prompt_param.DIALOGUE_START + _pd]
		var _prompt_dialogue_id = e_prompt_param.DIALOGUE_START + _pd
		var _prompt_dialogue_string = _random_prompt_array[_prompt_dialogue_id]
		
		# Replace all instances of code identifiers with respective words
		if _prompt_dialogue_string.contains("{0n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{0n}", _nouns[0][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{1n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{1n}", _nouns[1][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{2n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{2n}", _nouns[2][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{3n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{3n}", _nouns[3][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{4n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{4n}", _nouns[4][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{5n}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{5n}", _nouns[5][e_fill_in_word_param.WORD]);
		
		if _prompt_dialogue_string.contains("{0v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{0v}", _verbs[0][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{1v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{1v}", _verbs[1][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{2v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{2v}", _verbs[2][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{3v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{3v}", _verbs[3][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{4v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{4v}", _verbs[4][e_fill_in_word_param.WORD]);
		if _prompt_dialogue_string.contains("{5v}"): _prompt_dialogue_string = _prompt_dialogue_string.replace("{5v}", _verbs[5][e_fill_in_word_param.WORD]);
		
		# set new dialogue
		_random_prompt_array[_prompt_dialogue_id] = _prompt_dialogue_string
	
	
	return _random_prompt_array
	
func prompt_collect(_prompt_array, _e_prompt_type):
	
	# Puts the prompt into their respective collection for later use
	# _prompt_array is the information generated from the randomly generated prompt function
	
	match _e_prompt_type:
		e_prompt_type.NEGATIVE_MINOR:
			prompts_negative_collected.append(_prompt_array.duplicate())
		e_prompt_type.POSITIVE_MINOR:
			prompts_positive_collected.append(_prompt_array.duplicate())
	
	
	pass
