extends Node2D

var box_s = load("res://Objects/Box_a.tscn")
var fire = load("res://Objects/Fire.tscn")
var mage = load("res://NPCs/Mage.tscn")
var iceg = load("res://NPCs/Golem.tscn")
var slime = load("res://NPCs/Slime.tscn")
var msg_s = load("res://UI/MessageBox.tscn")
var overlay
var wpaused = false
#var shade = load("res://NPCs/Shadow.tscn")

var save_state = false

const WSX = -2000	#World min x
const WSY = -520	#World min y
const WEX = 1000	#World max x
const WEY = 3000	#World max y

func randVector2(xmin, xmax, ymin, ymax):
	return Vector2(rand_range(xmin, xmax), rand_range(ymin, ymax))
	
var objects = Array()
func spawn_instance(obj):
	objects.append(obj)
	add_child(objects.back())
	return objects.back()

func spawn_particles_at(obj, x, y):
	objects.append(obj.instance())
	add_child(objects.back())
	objects.back().set_global_position(Vector2(x, y))
	objects.back().emitting = true

func spawn_instance_at_r(obj, xmin, xmax, ymin, ymax):
	spawn_instance(obj).set_global_position(randVector2(xmin, xmax, ymin, ymax))

func spawn_object_at(obj, x, y):
	objects.append(obj.instance())
	add_child(objects.back())
	objects.back().set_global_position(Vector2(x, y))
	
func spawn_object_in_range(obj, x, y, rng):
	spawn_object_at(obj, x + rand_range(-rng, rng), y + rand_range(-rng, rng))

func spawn_objects_in_range(obj, x, y, rng, q = 1):
	while (q > 0):
		spawn_object_in_range(obj, x, y, rng)
		q -= 1

func spawn_instance_in_world(obj):
	spawn_instance_at_r(obj, WSX, WEX, WSY, WEY)

func spawn_instances_in_world(obj_res, q):
	var i = 0
	while (i < q):
		spawn_instance_in_world(obj_res.instance())
		i += 1

func update_score(points, kldg = 0, kldg2 = false):
	$GUI/score.text = str(points)

var player
func _ready():
	get_node("GUI").fade_out("Arcade", "", 2.2)
	randomize()
	player = get_node("Player")
	player.hp = 10
	player.max_hp = 10
	player.mana = 0
	Globals.map = filename
	print(get_node("Player").unlock_ability("Fireball"))
	#spawn_instances_in_world(box_s, 50)
	spawn_instances_in_world(fire, 6)
	spawn_instances_in_world(iceg, 4)
	spawn_instances_in_world(mage, 10)
	spawn_instances_in_world(slime, 17)
	
func show_msg(msg_str):		# Messagebox. Text can be split in pages using ";" razdelitel epta
							# Podtverzhdenie na klik mishki
	var dialog = msg_s.instance()
	dialog.get_node("RichTextLabel").dialog_text = msg_str
	dialog.get_node("RichTextLabel").init()
	overlay.add_child(dialog)	

func _on_Timer_timeout():
	if (objects.size() < 35):
		spawn_instance_in_world(iceg)
		spawn_instances_in_world(slime, 4)
		spawn_instances_in_world(mage, 5)
