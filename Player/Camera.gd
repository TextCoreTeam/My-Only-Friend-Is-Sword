extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const CAMERA_SPEED = 10.0
var target_pos
var loc
var mouse
var cap = 200
#func _process(delta):
#	loc = get_parent().get_node("Sprite").global_position
#	mouse = get_local_mouse_position()
#	target_pos = (loc + mouse) * 0.25
#	target_pos = target_pos.clamped(cap)
#	position = (position.linear_interpolate(target_pos, CAMERA_SPEED * delta))