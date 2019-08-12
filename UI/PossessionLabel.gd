extends Label

var start_pos
var rng = 2
var jumped = false
func _ready():
	start_pos = rect_global_position

var dst
func _process(delta):
	if (visible):
		if (!jumped):
			rect_global_position += Vector2(rand_range(-rng, rng), rand_range(-rng, rng))
			jumped = true
			return
		else:
			rect_global_position = start_pos
			jumped = false