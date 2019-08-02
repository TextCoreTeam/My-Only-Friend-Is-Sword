extends Node2D

var box_s = load("res://Box_a.tscn")
var ass_s = load("res://Enemy.tscn")

const WSX = -2000
const WSY = -520
const WEX = 1000
const WEY = 3000

var enemies = 0
const maxenemies = 20

func update_money_counter(mon):
	$GUI/MCount.text = "Score: " + str(mon)

func randVector2(xmin, xmax, ymin, ymax):
	return Vector2(rand_range(xmin, xmax), rand_range(ymin, ymax))

var boxes = 50

var objects = Array()

func _on_timer_timeout():
	print("New ass appears!")
	if (enemies < maxenemies):
		spawn_instance_in_world(ass_s.instance())
		enemies += 1
		$GUI/ECount.text = "Enemies: "+str(enemies)

func spawn_instance(obj):
	objects.append(obj)
	add_child(objects.back())
	return objects.back()

func spawn_instance_at_r(obj, xmin, xmax, ymin, ymax):
	spawn_instance(obj).set_global_position(randVector2(xmin, xmax, ymin, ymax))

func spawn_instance_in_world(obj):
	spawn_instance_at_r(obj, WSX, WEX, WSY, WEY)

func _ready():
	randomize()
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start()
	var i = 0
	while (i < boxes):
		spawn_instance_in_world(box_s.instance())
		i += 1

#func _process(delta):
#	pass
