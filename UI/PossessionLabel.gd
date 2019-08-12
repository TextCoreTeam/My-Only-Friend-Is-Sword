extends Label

var rng = 2
var jumped = false
var l
var t
var r
var b
func _ready():
	l = margin_left
	t = margin_top
	r = margin_right
	b = margin_bottom

var dst
func _process(delta):
	if (visible):
		if (!jumped):
			margin_left += rand_range(-rng, rng)
			margin_top += rand_range(-rng, rng)
			margin_right += rand_range(-rng, rng)
			margin_bottom += rand_range(-rng, rng)
			jumped = true
			return
		else:
			margin_left = l
			margin_top = t
			margin_right = r
			margin_bottom = b
			jumped = false