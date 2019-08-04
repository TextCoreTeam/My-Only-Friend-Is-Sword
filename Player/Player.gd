extends KinematicBody2D

var motion = Vector2.ZERO
const thrust_v = 1300
const speed_max_v = 350

var thrust = 1300
var speed_max = 350

var knock_resistance = 200
var sword_spawn_distance = 45

var money = 0
var hp = 10
var dead = false
var resistance_factor = 1

var can_throw = true
var has_sword = true
var throw_cooldown = 1

var knock_dir = Vector2.ZERO
var knock_baking = false

var mousepos
var aim_speed = deg2rad(3)
var sword_s = load("res://Projectiles/Sword.tscn")
var sword_speed = 600
onready var world = get_parent()
var my_weapon = null

var charge_pressed = true

func _on_progress_timeout():
	if $TextureProgress.value < 100 && Input.is_action_pressed("Charge"):
		$TextureProgress.value += 2.5
	else:
		$TextureProgress.visible = false
		sword_speed = sword_speed + 5 * $TextureProgress.value
		can_throw = false
		has_sword = false
		$SwordSprite.visible = false
		$ThrowTimer.start(throw_cooldown)
		throw_sword()
		$ChargeTimer.stop()
		$TextureProgress.value = 0
		sword_speed = 600
	
func knockback(velocity, maxspeed, kthrust):
	if (!knock_baking):
		thrust = kthrust
		speed_max = maxspeed
		knock_baking = true
		knock_dir = velocity.clamped(1) * (-1)

func reward():
	money += 1

func dmg(amt):
	$HPBar.value -= 1
	$HPBar.update()
	hp -= amt

func return_sword():
	has_sword = true
	$SwordSprite.visible = true

var sword_knock_thrust = 3000	#knockback on sword throw
var sword_knock_speed_max = 3000
onready var vertical_spawn_dst = sword_spawn_distance + 35
var aim_vertical = -1 #-1 -> no 0 -> up 1 -> down
func throw_sword():
	var rot = $MousePtr.get_rotation()
	mousepos = get_global_mouse_position()
	var spawn_point
	print(rot)
	var direction = Vector2(cos(rot), sin(rot))
	if (aim_vertical == 0 || aim_vertical == 1):
		print(mousepos.y - global_position.y)
		print("Throwing vertically " + str(aim_vertical))
		spawn_point = get_global_position() + direction * vertical_spawn_dst
	else:
		spawn_point = get_global_position() + direction * sword_spawn_distance		
	var sword = sword_s.instance()
	if (aim_vertical == 1):
		sword.get_node("RigidBody2D/Sprite").flip_v = true
	var world  = get_parent()
	world.add_child(sword)
	sword.set_global_position(spawn_point)
	sword.get_node('RigidBody2D').linear_velocity = (Vector2(cos(rot) * sword_speed, sin(rot) * sword_speed))
	knockback(sword.get_node('RigidBody2D').linear_velocity, sword_knock_speed_max, sword_knock_thrust)
	my_weapon = sword

	
	
func resummon_weapon():
	#my_weapon.get_node('RigidBody2D').linear_velocity = (player.get_global_position() - my_weapon.get_global_position()).normalized() * sword_speed * 2
	print("User-triggered bruh moment")
	my_weapon.queue_free()
	return_sword()     
	
func _ready():
	start_scale = scale
	$ThrowTimer.connect("timeout", self, "_on_throw_timeout")
	$ChargeTimer.connect("timeout", self, "_on_progress_timeout")
	

func _on_throw_timeout():
	can_throw = true
	$ThrowTimer.stop()

var start_scale
var flipped = false # !flipped -> facing right
func flip():
	if (!flipped):
		flipped = true
		$Sprite.flip_h = true
		$SwordSprite.flip_h = true
		$SwordSprite.position = Vector2(-28, 13) #TODO pridumat kak flipat ego bez etoy xuini
	else:
		flipped = false
		scale.x = start_scale.x
		$Sprite.flip_h = false
		$SwordSprite.flip_h = false
		$SwordSprite.position = Vector2(26, 13)

func turn_right():
	$MousePtr.look_at(mousepos)
	$SwordSprite.look_at(mousepos)
	if (flipped):
		flip()
	
func turn_left():
	$MousePtr.look_at(mousepos)
	$SwordSprite.look_at(mousepos)
	if (!flipped):
		flip()

func pdmg():
	pass

var mouse_angle
func _input(event):
	mousepos = get_global_mouse_position()
	mouse_angle = rad2deg($MousePtr.get_angle_to(mousepos))
	if (mousepos.x > self.global_position.x):
    	turn_right()
	else:
    	turn_left()
	
	if event is InputEventMouseButton:
		if (event.is_pressed() && event.button_index == BUTTON_LEFT && can_throw && has_sword):
			$TextureProgress.visible = true
			$ChargeTimer.start()
			
		elif (can_throw &&	#kuldaun ne tolko na brosok, no i na vozvrat
		event.is_pressed() &&
		event.button_index == BUTTON_RIGHT &&
		!has_sword):
			resummon_weapon()

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
		# Call showmsg map method

var axis = Vector2.ZERO
var collision
func _physics_process(delta):
	if (hp < 1):
		die()
		visible = false
	if (!dead && !knock_baking):
		axis = direction()
	if (!knock_baking):
		axis = Vector2.ZERO
	
	if (knock_baking):
		axis = knock_dir
		thrust -= knock_resistance
		if (thrust <= thrust_v):
			thrust = thrust_v
			knock_baking = false
			speed_max = speed_max_v
	
	if (axis == Vector2.ZERO):
		do_resistance(thrust * delta * resistance_factor)
	else:
		move(axis * thrust * delta)
	motion = move_and_slide(motion)
	
	collision = move_and_collide(Vector2.ZERO)
	if (collision):
		if (collision.get_collider().has_method("pick")):
			collision.collider.queue_free()
			return_sword()


func _on_AimUp_area_entered(area):
	if (area.has_method("mouseptr")):
		print("aim up entered")
		aim_vertical = 0


func _on_AimDown_area_entered(area):
	if (area.has_method("mouseptr")):
		print("aim down entered")
		aim_vertical = 1


func _on_AimUp_area_exited(area):
	if (area.has_method("mouseptr")):
		print("aim up exited")
		aim_vertical = -1


func _on_AimDown_area_exited(area):
	if (area.has_method("mouseptr")):
		print("aim down exited")
		aim_vertical = -1
