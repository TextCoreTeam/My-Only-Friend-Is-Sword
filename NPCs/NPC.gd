extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var start_pos
var rng = 2
var jumped = false
var pos_dst = 200
var player
func _ready():
	player = get_parent().get_node("Player")
	start_pos = $Label.rect_global_position

var dst
func _process(delta):
	dst = (player.global_position - global_position).length()
	if (dst <= pos_dst && !$Label.visible):
		$Label.visible = true
	if (dst > pos_dst && $Label.visible):
		$Label.visible = false
	if ($Label.visible):
		if (!jumped):
			$Label.rect_global_position += Vector2(rand_range(-rng, rng), rand_range(-rng, rng))
			jumped = true
			return
		else:
			$Label.rect_global_position = start_pos
			jumped = false
