extends Node2D

var box_s = load("res://Objects/Box_a.tscn")
var fire = load("res://Objects/Fire.tscn")
var mage = load("res://NPCs/Mage.tscn")
var iceg = load("res://NPCs/Golem.tscn")
var slime = load("res://NPCs/Slime.tscn")
var msg_s = load("res://UI/MessageBox.tscn")
var overlay

#var shade = load("res://NPCs/Shadow.tscn")

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

func spawn_instance_at_r(obj, xmin, xmax, ymin, ymax):
	spawn_instance(obj).set_global_position(randVector2(xmin, xmax, ymin, ymax))

func spawn_instance_in_world(obj):
	spawn_instance_at_r(obj, WSX, WEX, WSY, WEY)

func spawn_instances_in_world(obj_res, q):
	var i = 0
	while (i < q):
		spawn_instance_in_world(obj_res.instance())
		i += 1

func update_score(points):
	$GUI/score.text = "Score: " + str(points)
	
func _ready():
	randomize()
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
