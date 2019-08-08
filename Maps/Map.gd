extends Node2D

#	Methods and properties that are common for all maps
var wpaused = false
var name_str	# Map name
#var overlay
var msg_s = load("res://UI/MessageBox.tscn")
func update_score(points):
	$GUI/score.text = "Score: " + str(points)

func show_msg(msg_str):		# Messagebox. Text can be split in pages using ";" razdelitel epta
							# Podtverzhdenie na klik mishki
	wpaused = true
	var dialog = msg_s.instance()
	dialog.get_node("RichTextLabel").dialog_text = msg_str
	dialog.get_node("RichTextLabel").init()
	$GUI.add_child(dialog)

func update_map_name():
	$GUI/LevelName.text = name_str

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass