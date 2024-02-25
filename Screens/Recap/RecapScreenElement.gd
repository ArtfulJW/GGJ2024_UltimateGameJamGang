extends Control
@onready var recap_label = $ColorRect/text_container/Recap_Label
@onready var text_container = $ColorRect/text_container

var scroll_speed = 10
var start_y

func _ready():
	start_y = text_container.position.y

func update_progress_textbox():
	recap_label.text = ""
	for recap_string in GlobalData.prompt_array_storage:
		recap_label.text += recap_string + '\n'
	text_container.position.y = start_y

func _process(delta):
	if visible == true:
		text_container.position.y -= float(scroll_speed) * delta
