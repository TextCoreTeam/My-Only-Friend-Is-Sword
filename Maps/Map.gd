extends Node2D

#	Methods and properties that are common for all maps
var show_exp = false
var wpaused = false
var save_state
var name_str	# Map name
#var overlay
var msg_s = load("res://UI/MessageBox.tscn")
func update_score(xp, rexp, lvup):
	$GUI/ExpBar/ExpLabel.text = str(xp) + " / " + str(rexp)
	$GUI/ExpBar/LvlLabel.text = str(player.lvl)
	$GUI/ExpBar.value = xp
	$GUI/ExpBar.max_value = rexp
	if (lvup):
		$GUI/ExpBar.min_value = xp
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

onready var player = get_node("Player")
func _ready():
	randomize()
	if (Globals.game_mode == 0):
		get_node("GUI/score").visible = false
	Globals.map = filename
	print("loaded " + Globals.map)
	if (save_state && Globals.destroyed_entities.has(Globals.map)):
		var lg = Globals.destroyed_entities[Globals.map].size()
		var i = 0
		while(i < lg):
			get_node(Globals.destroyed_entities[Globals.map][i]).queue_free()
			i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass