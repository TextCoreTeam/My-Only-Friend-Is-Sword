extends KinematicBody2D

export var MAX_SPEED = 400
export var JUMP_FORCE = 700
export var GRAVITY = 35
export var MAX_FALL_SPEED = 1000
var thrust = 1000

var y_velo = 0
var points = 0
var motion = Vector2.ZERO


func do_resistance(amt):
	if (motion.length() > amt):
		motion -= motion.normalized() * amt
	else:
		motion = Vector2.ZERO
	
func move(amt):
	motion += amt
	motion = motion.clamped(MAX_SPEED)

func direction():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	axis.y = 0
	return axis.normalized()

var axis
func _physics_process(delta):
	axis = direction()
	var move_dir = 0
	if Input.is_key_pressed(KEY_D):
		move_dir += 1
	if Input.is_key_pressed(KEY_A):
		move_dir -= 1
	if (axis == Vector2.ZERO):
		do_resistance(thrust * delta)
	else:
		move(axis * thrust * delta)
	move_and_slide(motion + Vector2(0, y_velo), Vector2(0, -1))
	var grounded = is_on_floor()
	y_velo += GRAVITY
	if grounded and Input.is_key_pressed(KEY_SPACE):
		y_velo = -JUMP_FORCE
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED

func p_inc():
	points +=1
	get_parent().get_node("HUD/ShowPoints").text = str("Points:", points)
	