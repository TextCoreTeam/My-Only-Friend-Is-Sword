extends KinematicBody2D

var hp = 2
var speed
var player
var can_take_dmg = true

func _on_takedmg_timeout():
	can_take_dmg = true
	$TakeDMGTimer.stop()

func _ready():
	$Blood.emitting = false
	player = get_parent().get_parent().get_node("Player")
	pid = player.get_instance_id()
	$TakeDMGTimer.connect("timeout", self, "_on_takedmg_timeout")
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$ShootTimer.connect("timeout", self, "_on_shoot_timeout")
	$ShootTimer.start()
	speed = rand_range(50, 200)
	pass

var bullet_s = load("res://Projectiles/Bullet.tscn")
func _on_shoot_timeout():
	if (!detected):
		return
	var bullet_speed = 6
	var direction = Vector2(cos(get_rotation()), sin(get_rotation()))
	var spawn_distance = 70
	var spawn_point = get_global_position() + direction * spawn_distance
	var bullet = bullet_s.instance()
	var world  = get_parent().get_parent()
	bullet.get_node("Bullet_area/Sprite").frame = 0
	world.add_child(bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(cos(get_rotation()) * bullet_speed, sin(get_rotation()) * bullet_speed))
	pass

func _on_timer_timeout():
	can_attack = true
	$Timer.stop()

func mob():	#kludge for mob identification because im a f4g
	pass

var blood_s = load("res://Particles/Blood.tscn")
func dmg():
	if (can_take_dmg):
		print("Mob took damage")
		$TakeDMGTimer.start(1)
		can_take_dmg = false
		$Blood.emitting = true
		hp -= 1

var pid
var can_attack = true
var collision
var turn_speed = deg2rad(4)

var dir	# vector difference between player and enemy
var dst	# distance to player

var detected = false
const visibility_dst = 300
const lose_dst = 1500	# Distance at which enemy loses sight of player

func _physics_process(delta):
	if (hp < 1):
		player.reward()
		get_parent().get_parent().enemies -= 1
		get_parent().get_parent().get_node("GUI/ECount").text = "Enemies: "+str(get_parent().get_parent().enemies)
		queue_free()
	dst = (player.global_position - global_position).length()
	dir = (player.global_position - global_position).normalized()
	
	if (dst <= visibility_dst && !detected):
		print("Detected player")
		detected = true
	
	if (dst >= lose_dst && detected):
		print("Lost sight of player")
		detected = false
	
	if (detected):
		if get_angle_to(player.global_position) > 0:
    		rotation += turn_speed
		else:
    		rotation -= turn_speed
		collision = move_and_collide(dir * speed * delta)
		if (collision && can_attack && collision.get_collider().has_method("pdmg")):
			collision.collider.dmg()
			can_attack = false
			$Timer.start()
