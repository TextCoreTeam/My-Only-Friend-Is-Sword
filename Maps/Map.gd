extends Node2D

#	Methods and properties that are common for all maps
var wpaused = false
var name_str	# Map name
#var overlay
var msg_s = load("res://UI/MessageBox.tscn")
func update_score(points):
	$GUI/score.text = "Score: " + str(points)

var objects = Array()

func spawn_particles_at(obj, x, y):
	objects.append(obj.instance())
	add_child(objects.back())
	objects.back().set_global_position(Vector2(x, y))
	objects.back().emitting = true
	
func spawn_object_at(obj, x, y):
	objects.append(obj.instance())
	add_child_below_node($Bottom, objects.back())
	objects.back().set_global_position(Vector2(x, y))
	
func spawn_object_in_range(obj, x, y, rng):
	spawn_object_at(obj, x + rand_range(-rng, rng), y + rand_range(-rng, rng))

func spawn_objects_in_range(obj, x, y, rng, q = 1):
	while (q > 0):
		spawn_object_in_range(obj, x, y, rng)
		q -= 1

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