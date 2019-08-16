extends KinematicBody2D

export var boss_name = "IceGolem"
onready var world = get_parent()
func _ready():
	pass
	
func _physics_process(delta):
	if (world.has_node(boss_name)):
		return
	else:
		print("!!!!!!!!!!!!!!!!!!!!!!!!! Boss killed. Removing barrier...")
		queue_free()