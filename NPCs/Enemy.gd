extends KinematicBody2D

var hp
var damage_amount
var speed
var player
var can_take_dmg = true

var attack_frame
var melee_cooldown
var bullet_speed

var visibility_dst
var lose_dst	# Distance at which enemy loses sight of player

var has_range_attack
var has_melee_attack

var mscale = Vector2.ZERO
func _on_takedmg_timeout():
	can_take_dmg = true
	$TakeDMGTimer.stop()
	$Blood.emitting = false
var cscale
func _ready():
	cscale = get_scale()
	mscale.x = cscale.x
	mscale.y = cscale.y
	$Blood.emitting = false
	player = get_parent().get_parent().get_node("Player")
	pid = player.get_instance_id()
	$TakeDMGTimer.connect("timeout", self, "_on_takedmg_timeout")
	$ShootTimer.connect("timeout", self, "_on_shoot_timeout")
	$ShootTimer.start()
	pass

var bullet_s = load("res://Projectiles/Bullet.tscn")
func _on_shoot_timeout():
	if (!detected || !has_range_attack):
		return
	var direction = Vector2(cos($Aim.get_rotation()), sin($Aim.get_rotation()))
	var spawn_distance = 70
	var spawn_point = get_global_position() + direction * spawn_distance
	var bullet = bullet_s.instance()
	var world  = get_parent().get_parent()
	bullet.get_node("Bullet_area/Sprite").frame = 0
	world.add_child(bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(cos($Aim.get_rotation()) * bullet_speed, sin($Aim.get_rotation()) * bullet_speed))
	pass

func _on_AttackCooldown_timeout():
	can_attack = true
	print("Mob can attack again")
	$AttackCooldown.stop()

func mob():	#kludge for mob identification because im a f4g
	pass

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

var attack_in_progress = false

var dir	# vector difference between player and enemy
var dst	# distance to player

var detected = false
var heading_right = true #false->left true->right

func turn_right():
	print("to the right")
	if (!heading_right):
		heading_right = true
		$Aim.rotation -= turn_speed
		set_scale(Vector2(cscale.x, cscale.y))

func turn_left():
	print("to the left")
	if (heading_right):
		heading_right = false
		$Aim.rotation += turn_speed
		set_scale(Vector2(cscale.x, cscale.y))

var player_in_melee_hitbox = false

func attack(body):
	body.knockback(dir * (-1))
	body.dmg(damage_amount)
	can_attack = false
	$AttackCooldown.start(melee_cooldown)

func attack_prepare():
	attack_in_progress = true
	print("Playing attack animation")
	$AnimationPlayer.play("attack_lr")

var angle
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
		if (attack_in_progress &&
				stepify($AnimationPlayer.current_animation_position, 0.1) == attack_frame &&
				$MeleeHitbox.overlaps_body(player) && player_in_melee_hitbox &&
				can_attack &&
				has_melee_attack):
			print("Gotcha, fucker!")
			attack(player)
		angle = rad2deg($Aim.get_angle_to(player.global_position))
		print(angle)	#90 -> player is above -90 -> player is under enemy
						#-180 -> player is to the right	0 -> player is to the left
		if (angle <= 130 && angle >= 30):
			print("above")
		elif (angle >= -130 && angle <= -30):
			print("below")
		elif (angle <= 30 && angle >= -30):
    		turn_left()
		else:
    		turn_right()
		collision = move_and_collide(dir * speed * delta)
		if (!attack_in_progress &&
				$MeleeZone.overlaps_body(player) &&
				can_attack &&
				has_melee_attack):
			print("Player is in melee zone, preparing attack")
			attack_prepare()


func _on_MeleeHitbox_body_entered(body):
	if (body.has_method("pdmg")):
			player_in_melee_hitbox = true

func _on_MeleeHitbox_body_exited(body):
	if (body.has_method("pdmg")):
		player_in_melee_hitbox = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "attack_lr"):
		attack_in_progress = false
