extends Node2D

#	Methods and properties that are common for all maps

var name_str	# Map name
var overlay
var msg_s = load("res://UI/MessageBox.tscn")

func show_msg(msg_str):		# Messagebox. Text can be split in pages using ";" razdelitel epta
							# Podtverzhdenie na klik mishki
	var dialog = msg_s.instance()
	dialog.get_node("RichTextLabel").dialog_text = msg_str
	dialog.get_node("RichTextLabel").init()
	overlay.add_child(dialog)

func update_map_name():
	$GUI/LevelName.text = name_str

func _ready():
	randomize()
	overlay = $GUI
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass