extends KinematicBody2D

var hp = 5
var speed
var player

func _ready():
	player = get_parent().get_parent().get_node("Player")
	pid = player.get_instance_id()
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$ShootTimer.connect("timeout", self, "_on_shoot_timeout")
	$ShootTimer.start()
	speed = rand_range(50, 200)
	pass

var bullet_s = load("res://Bullet.tscn")
func _on_shoot_timeout():
	var bullet_speed = 6
	var direction = Vector2(cos(get_rotation()), sin(get_rotation()))
	var spawn_distance = 70
	var spawn_point = get_global_position() + direction * spawn_distance
	var bullet = bullet_s.instance()
	var world  = get_parent().get_parent()
	bullet.get_node("Bullet_area/Sprite").frame = 1
	world.add_child(bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(cos(get_rotation()) * bullet_speed, sin(get_rotation()) * bullet_speed))
	pass

func _on_timer_timeout():
	can_attack = true

var blood_s = load("res://Blood.tscn")
func dmg():
	$Blood.emitting = true
	hp -= 1

var pid
var can_attack = true
var collision
var turn_speed = deg2rad(4)

func _physics_process(delta):
	if (hp < 1):
		player.reward()
		get_parent().get_parent().enemies -= 1
		get_parent().get_parent().get_node("GUI/ECount").text = "Enemies: "+str(get_parent().get_parent().enemies)
		queue_free()
	var dir = (player.global_position - global_position).normalized()
	if get_angle_to(player.global_position) > 0:
    	rotation += turn_speed
	else:
    	rotation -= turn_speed
	collision = move_and_collide(dir * speed * delta)
	if (collision && can_attack && collision.get_collider().has_method("pdmg")):
		collision.collider.dmg()
		can_attack = false
		$Timer.start()