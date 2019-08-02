extends KinematicBody2D

export var MOVE_SPEEED = 500
export var JUMP_FORCE = 1000
export var GRAVITY = 50
export var MAX_FALL_SPEED = 1000

var y_velo = 0
var points = 0

func _physics_process(delta):
	if get_parent().get_node("HUD").start == true:
		var move_dir = 0
		if Input.is_action_pressed('ui_right'):
			move_dir += 1
		if Input.is_action_pressed('ui_left'):
			move_dir -= 1
		move_and_slide(Vector2(move_dir * MOVE_SPEEED, y_velo), Vector2(0, -1))
		
		var grounded = is_on_floor()
		y_velo += GRAVITY
		if grounded and Input.is_action_pressed('ui_up'):
			y_velo = -JUMP_FORCE
		if grounded and y_velo >= 5:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED

func p_inc():
	points +=1
	get_parent().get_node("HUD/ShowPoints").text = str("Points:", points)
	