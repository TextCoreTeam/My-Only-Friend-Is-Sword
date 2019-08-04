extends Node2D

var box_s = load("res://Objects/Box_a.tscn")
var fire = load("res://Objects/Fire.tscn")
var mage = load("res://NPCs/Mage.tscn")
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

func _ready():
	randomize()
	#spawn_instances_in_world(box_s, 50)
	spawn_instances_in_world(fire, 15)
<<<<<<< HEAD
	spawn_instances_in_world(mage, 15)
	#spawn_instances_in_world(shade, 40)
=======
	spawn_instances_in_world(mage, 20)
>>>>>>> parent of 53d8647... Animated mage projectiles, no ranged attack slimes
