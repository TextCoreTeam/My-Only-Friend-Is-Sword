extends KinematicBody2D

var reward
var hp
var damage_amount
var speed
var player
var can_take_dmg = true
var mana_drop

var p_resist
var p_sprite
var p_idle_anim
var p_hp
var p_thrust
var p_maxspeed
var p_walk

var possessable

var knock_speed_damp	#knockback when hit by player
var knock_speed
var knock_time

var ondeath_particles = preload("res://Particles/Ondeath.tscn")

var bullet_type

var knock_maxspeed	#player knockback
var knock_thrust

var attack_frame
var melee_cooldown
var bullet_speed

var visibility_dst
var lose_dst	# Distance at which enemy loses sight of player

var has_range_attack
var has_melee_attack

func _on_takedmg_timeout():
	can_take_dmg = true
	$TakeDMGTimer.stop()
	$Blood.emitting = false
var start_scale
var player_ptr
var world
var shake_amt
var mobname

onready var navigation = get_parent().get_parent().get_node("Navigation2D")
onready var map = get_parent().get_parent().get_node("Navigation2D/PhysicalLayer")

func _ready():
	$TakeDMGTimer.wait_time = 0.8
	$MobInfo/MobInfo.text = mobname
	$MobInfo/MobInfo/HPBar.max_value = hp
	$MobInfo/MobInfo/HPBar.value = hp
	$MobInfo/MobInfo/HPBar.update()
	$MobInfo/MobInfo/HPBar/HpLabel.text = str(hp)
	world = get_parent().get_parent()
	player_ptr = get_parent().get_node("PlayerPtr")
	start_scale = scale
	$Blood.emitting = false
	player = get_parent().get_parent().get_node("Player")
	pid = player.get_instance_id()
	$TakeDMGTimer.connect("timeout", self, "_on_takedmg_timeout")
	$ShootTimer.connect("timeout", self, "_on_shoot_timeout")
	$ShootTimer.start()
	pass

var knock
var knock_baking = false
func knockback(amt):
	knock = amt
	knock_baking = true
	$KnockTimer.start(knock_time)

var bullet_s = load("res://Projectiles/Bullet.tscn")
func _on_shoot_timeout():
	if (!detected || !has_range_attack || world.wpaused):
		return
	var rot = player_ptr.rotation
	var direction = (player.global_position - global_position).normalized()
	var spawn_distance = 70
	var spawn_point = get_global_position() + direction * spawn_distance
	var bullet = bullet_s.instance()
	var world  = get_parent().get_parent()
	bullet.get_node("Bullet_area/Sprite").frame = bullet_type
	world.add_child(bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(direction.x * bullet_speed, direction.y * bullet_speed))
	pass

func _on_AttackCooldown_timeout():
	can_attack = true
	print("Mob can attack again")
	$AttackCooldown.stop()

func mob():	#kludge for mob identification because im a f4g
	pass

func dmg(num = 1):
	if (can_take_dmg):
		if (!detected):
			detected = true
		print("Mob took damage")
		$TakeDMGTimer.start(1)
		can_take_dmg = false
		$Blood.emitting = true
		hp -= num
		$MobInfo/MobInfo/HPBar.value = hp
		$MobInfo/MobInfo/HPBar.update()
		$MobInfo/MobInfo/HPBar/HpLabel.text = str(hp)

var pid
var can_attack = true
var collision
var turn_speed = deg2rad(4)

var attack_in_progress = false

var dir	# vector difference between player and enemy
var dst	# distance to player

var detected = false
var heading_right = true #false->left true->right

var w_offset
func turn_right():
	if (!heading_right):
		player_above = -1
		heading_right = true
		$WalkAnimLR.flip_h = false
		$AttackAnimLR.flip_h = false
		$WalkAnimLR.offset = Vector2.ZERO
		$AttackAnimLR.offset = Vector2.ZERO
		#scale.x *= -1
		#$Aim.scale.x *= -1
		#if (possessable):
		#	$Possession.scale.x *= -1
		#$MobInfo.scale.x *= -1
	
func turn_left():
	if (heading_right):
		player_above = -1
		heading_right = false
		$WalkAnimLR.flip_h = true
		$AttackAnimLR.flip_h = true
		$WalkAnimLR.offset = Vector2(w_offset, 0)
		$AttackAnimLR.offset = Vector2(w_offset, 0)
		#scale.x = -start_scale.x
		#$Aim.scale.x = -start_scale.x
		#if (possessable):
		#	$Possession.scale.x = -start_scale.x
		#$MobInfo.scale.x = -start_scale.x

var player_in_melee_hitbox = false

func attack(body):
	body.knockback(dir * (-1), knock_maxspeed, knock_thrust, false)
	body.dmg(damage_amount)
	body.get_node("Camera2D").shake(1, shake_amt, 5)
	can_attack = false
	$AttackCooldown.start(melee_cooldown)

func attack_prepare():
	$WalkAnimLR.visible = false
	$AttackAnimLR.visible = true
	moving = false
	attack_in_progress = true
	print("Playing attack animation")
	$AnimationPlayer.play("attack_lr")

var mana_s = load("res://Objects/ManaCrystal.tscn")
func spawn_mana():
	world.spawn_objects_in_range(mana_s, global_position.x, global_position.y, 10)

var angle
var moving = false
var possessed = false
var player_above = -1	#0 -> player is above the mob || 1-> player is under the mob || -1 -> fuck you
onready var me = get_parent().get_path()
func _physics_process(delta):
	if (possessed):
		if (world.save_state):
			Globals.remove_from_map(me)
		get_parent().queue_free()
	if (hp < 1):
		player.reward(reward)
		spawn_mana()
		world.spawn_particles_at(ondeath_particles, global_position.x, global_position.y)
		if (world.save_state):
			Globals.remove_from_map(me)
			print("added " + me + " to destroyed list")
		get_parent().queue_free()
	if (world.wpaused):
		return
	dst = (player.global_position - global_position).length()
	dir = (player.global_position - global_position).normalized()
	# ((navigation.get_closest_point(player.global_position)) - global_position).normalized()
	#
	if (knock_baking):
		knock *= knock_speed_damp
		dir *= -1 * knock
	
	if (dst <= visibility_dst && !detected):
		print("Detected player")
		detected = true
	
	if (dst >= lose_dst && detected):
		print("Lost sight of player")
		detected = false
	
	if (detected):
		player_ptr.look_at(player.global_position)
		if (!moving && !attack_in_progress):
			$WalkAnimLR.visible = true
			$AnimationPlayer.play("walk_lr")
			$AttackAnimLR.visible = false
			moving = true
		if (attack_in_progress &&
				stepify($AnimationPlayer.current_animation_position, 0.1) == attack_frame &&
				$MeleeHitbox.overlaps_body(player) && player_in_melee_hitbox &&
				can_attack &&
				has_melee_attack):
			print("Gotcha, fucker!")
			attack(player)
		angle = rad2deg($PAim.get_angle_to(player.global_position))
						#90 -> player is above -90 -> player is under enemy
						#-180 -> player is to the right	0 -> player is to the left
		#if (angle <= 130 && angle >= 30):
		#	player_above = 0
		#elif (angle >= -130 && angle <= -30):
		#	player_above = 1
		#el
		if (global_position.x > player.global_position.x):
    		turn_left()
		else:
    		turn_right()

		if (!knock_baking):
			collision = move_and_collide(dir * speed * delta)
		else:
			collision = move_and_collide(dir * knock_speed * delta)

		if (collision && collision.collider.has_method("mob")):
			add_collision_exception_with(collision.collider)
		if (collision && collision.collider.has_method("object_passable")):
			add_collision_exception_with(collision.collider)
		
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


func _on_KnockTimer_timeout():
	knock_baking = false
	$KnockTimer.stop()
