extends KinematicBody2D

var motion = Vector2.ZERO
var thrust = 1300
var speed_max = 350

var money = 0
var hp = 10
var dead = false
var resistance_factor = 1

var can_throw = true
var throw_cooldown = 5

var mousepos
var aim_speed = deg2rad(3)
var bullet_s = load("res://Bullet.tscn")
var dialog_s = load("res://MessageBox.tscn")
var bullet_speed = 10
onready var world = get_parent()

func reward():
	money += 1
	world.update_money_counter(money)

func dmg():
	$HPBar.value -= 1
	$HPBar.update()
	hp -= 1

func spawnProjectile():
	var direction = Vector2(cos(get_rotation()), sin(get_rotation()))
	var spawn_distance = 70
	var spawn_point = get_global_position() + direction * spawn_distance
	var bullet = bullet_s.instance()
	var world  = get_parent()
	world.add_child(bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(cos(get_rotation()) * bullet_speed, sin(get_rotation()) * bullet_speed))
func _ready():
	$ThrowTimer.connect("timeout", self, "_on_throw_timeout")

func _on_throw_timeout():
	can_throw = true
	$ThrowTimer.stop()

func pdmg():
	pass

func _input(event):
	mousepos = get_global_mouse_position()
	
	if get_angle_to(mousepos) > 0:
    	rotation += aim_speed
	else:
    	rotation -= aim_speed
	
	if event is InputEventMouseButton:
		if (event.is_pressed() && event.button_index == BUTTON_LEFT && can_throw):
			can_throw = false
			$ThrowTimer.start(throw_cooldown)
			spawnProjectile()

func do_resistance(amt):
	if (motion.length() > amt):
		motion -= motion.normalized() * amt
	else:
		motion = Vector2.ZERO
	
func move(amt):
	motion += amt
	motion = motion.clamped(speed_max)

func direction():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	axis.y = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	return axis.normalized()

func die():
	if (!dead):
		get_parent().get_node("Timer").stop()
		dead = true
		var dialog = dialog_s.instance()
		dialog.get_node("RichTextLabel").dialog_text = "You died bruh"
		dialog.get_node("RichTextLabel").init()
		var world  = get_parent().get_node("CanvasLayer")
		world.add_child(dialog)

var axis
func _physics_process(delta):
	if (hp < 1):
		die()
		visible = false
	if (!dead):
		axis = direction()
	else:
		axis = Vector2.ZERO
	
	if (axis == Vector2.ZERO):
		do_resistance(thrust * delta * resistance_factor)
	else:
		move(axis * thrust * delta)
	motion = move_and_slide(motion)
