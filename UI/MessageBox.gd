extends RichTextLabel

var delta_time = 0
export var speed = 0.05
export(String, MULTILINE) var dialog_text = ""
var current_page = 0
var pages = []
var player

func init():
	visible_characters = 0
	parse_dialog_text()
	text = pages[current_page]
	set_process_input(true)
	set_process(true)

func _ready():
	 pass

func parse_dialog_text():
	pages = dialog_text.split(";")
	for i in range(pages.size()):
		pages[i] = pages[i].replace("\n","")

func text_advance():
	if(text.length() == visible_characters):
		current_page = current_page + 1
		visible_characters = 0
		delta_time = 0
		if(pages.size() - 1 >= current_page):
			text = pages[current_page]
		else:
			get_parent().get_parent().get_parent().wpaused = false
			get_parent().queue_free()

func text_update():
	if(text.length() > visible_characters):
		visible_characters = visible_characters + 1

func _input(event):
	if(event.is_pressed() && event is InputEventMouseButton && event.button_index == BUTTON_RIGHT):
		if(visible_characters == text.length()):
			text_advance()
		else:
			visible_characters = text.length()
	if (event.is_pressed() && event is InputEventMouseButton && event.button_index == BUTTON_LEFT):
		get_parent().get_parent().get_parent().wpaused = false
		get_parent().queue_free()

func _process(delta):
	if(delta_time > speed):
		delta_time = 0
		text_update()
	delta_time = delta_time + delta
