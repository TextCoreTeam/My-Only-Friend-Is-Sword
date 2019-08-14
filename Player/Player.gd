extends KinematicBody2D

var can_walk = false
var can_sword_attack = true

var motion = Vector2.ZERO

# *_v --> standard value, used to reset from powerups, etc

const thrust_v = 1300
const speed_max_v = 350

var thrust_p
var speed_max_p
var knock_resistance_p

var ability_current = 0
var ability_cost = 0
var ability_name = ""

var mana = 0
var max_mana = 5

var max_hp_v = 10
var max_hp = max_hp_v
var hp = max_hp
var hp_v = hp

var thrust = 1300
var speed_max = 350

var retract_step
var knock_resistance = 170
var knock_resistance_v = 170
var sword_spawn_distance = 20
var money = 0
var dead = false
var resistance_factor = 1

var can_throw = true
var has_sword = true
var throw_cooldown = 0.8

var knock_dir = Vector2.ZERO
var knock_baking = false

var mousepos
var aim_speed = deg2rad(3)
var sword_speed = 600
onready var world = get_parent()
var my_weapon = null

var charge_pressed = true

var velo_bonus #velocity bonus when thrown back by sword

var possessing = false

var explosion_s = load("res://Particles/Explosion.tscn")
var sword_s = load("res://Projectiles/Sword.tscn")
var pspell_s = load("res://Projectiles/PSpell.tscn")

func set_hp(amt, maxhp):
	hp = amt
	$HPBar.max_value = maxhp
	$HPBar.value = amt
	$HPBar.update()
	$HPLabel.text = str(amt)
	
func set_mana(amt, maxmana):
	mana = amt
	$ManaProgress.max_value = maxmana
	$ManaProgress.value = amt
	$ManaProgress.update()
	$ManaLabel.text = str(amt)

var p_sprite
func possess_revert(force = false):
	$Camera2D.shake(3, 30, 10)
	world.spawn_particles_at(explosion_s, global_position.x, global_position.y)
	possessing = false
	get_node(p_sprite).visible = false
	$Sprite.visible = true
	can_walk = false
	can_sword_attack = true
	thrust = thrust_v
	speed_max = speed_max_v
	knock_resistance = knock_resistance_v
	if (force):
		hp_v -= round(max_hp_v / 3)
	set_hp(hp_v, max_hp_v)
	$AnimationPlayer.stop()

func possess():
	$Camera2D.shake(3, 30, 10)
	global_position = pos_body.global_position
	world.spawn_particles_at(explosion_s, global_position.x, global_position.y)
	p_sprite = pos_body.p_sprite
	print("Possessing " + p_sprite)
	get_node(p_sprite).visible = true
	thrust_p = pos_body.p_thrust
	thrust = thrust_p
	speed_max_p = pos_body.p_maxspeed
	speed_max = speed_max_p
	can_walk = pos_body.p_walk
	knock_resistance_p = pos_body.p_resist
	knock_resistance = knock_resistance_p
	$AnimationPlayer.play(pos_body.p_idle_anim)
	hp_v = hp
	set_hp(pos_body.p_hp, pos_body.p_hp)
	pos_body.possessed = true
	can_sword_attack = false
	#$CollisionShape2D.disabled = false # It fucking doesn't work, godot devs are cucks
	collision_layer = start_layer
	collision_mask = start_mask
	possessing = true
	print($CollisionShape2D.disabled)
	print(knock_baking)

func _on_progress_timeout():
	if ($TextureProgress.value < $TextureProgress.max_value &&
		Input.is_action_pressed("Charge")):
		$TextureProgress.value += 3.5
	else:
		$TextureProgress.visible = false
		sword_speed = sword_speed + 5 * $TextureProgress.value
		velo_bonus = $TextureProgress.value
		can_throw = false
		has_sword = false
		$SwordSprite.visible = false
		throw_sword()
		$RetractBar.visible = true
		$RetractTimer.start(retract_step)
		$ThrowTimer.start(throw_cooldown)
		$ChargeTimer.stop()
		$TextureProgress.value = 0
		sword_speed = 600
	
func knockback(velocity, maxspeed, kthrust, use_bonus = false, resistance = 170):
	if (!false):
		print("Knock bonus: " + str(velo_bonus) + " " + str(use_bonus))
		if (use_bonus):
			if (velo_bonus > 0 && velo_bonus < 100):
				velo_bonus *= 3
			else:
				velo_bonus *= 6.1
			thrust = kthrust + velo_bonus
		else:
			thrust = kthrust
		speed_max = maxspeed
		knock_resistance = resistance
		knock_baking = true
		knock_dir = velocity.clamped(1) * (-1)
		print (str(knock_dir) + " | " + str(thrust) + " / "+ str(maxspeed))

onready var gui = world.get_node("GUI")
func add_mana(amt = 1):
	mana += amt
	if (mana >= max_mana):
		mana = max_mana
	$ManaProgress.value = mana
	$ManaProgress.update()
	$ManaLabel.text = str(mana)
	gui.switch_ability()

func reward(money_r):
	money += money_r
	get_parent().update_score(money)

func dmg(amt):
	hp -= amt
	$HPBar.value = hp
	$HPBar.update()
	$HPLabel.text = str(hp)

func return_sword():
	has_sword = true
	my_weapon.get_node("RigidBody2D").knock_speed_max = 3000
	my_weapon.get_node("RigidBody2D").knock_thrust = 5000
	my_weapon.get_node("RigidBody2D").upgraded = ""
	my_weapon.get_node("RigidBody2D").dmg_num = 1
	$RetractAnim.hide()
	$AnimationPlayer.stop()
	#$SwordSprite.visible = true

var sword_knock_thrust = 2500	#knockback on sword throw
var sword_knock_speed_max = 3000
onready var vertical_spawn_dst = sword_spawn_distance + 25
var aim_vertical = -1 #-1 -> no 0 -> up 1 -> down
func throw_sword():
	var rot = $MousePtr.get_rotation()
	mousepos = get_global_mouse_position()
	var spawn_point
	var direction = Vector2(cos(rot), sin(rot))
	if (aim_vertical == 0 || aim_vertical == 1):
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
	knockback(sword.get_node('RigidBody2D').linear_velocity, sword_knock_speed_max, sword_knock_thrust, false)
	my_weapon = sword

func unlock_ability(name):
	var i = Globals.ability_list.size() - 1 
	while (i >= 0):
		if (Globals.ability_list[i] == name):
			gui.add_ability(i)
			return true
		i -= 1
	return false

var spell_speed = 500
func cast_pspell():
	mana -= ability_cost
	set_mana(mana, max_mana)
	$ManaLabel.text = str(mana)
	$ManaProgress.value = mana
	$ManaProgress.update()
	var rot = $MousePtr.get_rotation()
	var spawn_point
	var direction = Vector2(cos(rot), sin(rot)) * -1
	spawn_point = get_global_position()# + direction * sword_spawn_distance
	var proj = pspell_s.instance()	
	var world  = get_parent()
	self.add_child(proj)
	$Sprite.visible = false
	collision_layer = 30
	collision_mask = 30
	#$CollisionShape2D.disabled = true #godot sucks my balls
	proj.set_global_position(spawn_point)
	knockback(direction, 3000, 3000, false, 5)
	gui.switch_ability()
	pass
	
func cast_fireball():
	mana -= ability_cost
	set_mana(mana, max_mana)
	gui.switch_ability()
	fire_projectile(fireball_s)

var fireball_s = load("res://Projectiles/p_fireball.tscn")
func fire_projectile(body, speed = 4, dst = 15):
	var rot = $MousePtr.get_rotation()
	var spawn_point
	var direction = Vector2(cos(rot), sin(rot))
	spawn_point = get_global_position() + direction * dst
	var bullet = body.instance()	
	world.add_child_below_node(world.get_node("Bottom"), bullet)
	bullet.set_global_position(spawn_point)
	bullet.get_node('Bullet_area').velocity = (Vector2(cos(rot) * speed, sin(rot) * speed))

func resummon_weapon():
	print("User-triggered bruh moment")
	my_weapon.get_node("RigidBody2D").return_back()
	
var rbar_step
onready var map = get_parent().get_node("Navigation2D/TileMap")

func checkpoint_create(pos):
	Globals.temp_entities.clear()
	for prop_name in Globals.player.keys():
		if (prop_name == "map" || prop_name == "global_position"):
			continue
		print("Saving " + prop_name + ": " + str(get(prop_name)))
		Globals.player[prop_name] = get(prop_name)
	Globals.player["global_position"] = pos
	Globals.player["map"] = Globals.map
	
func checkpoint_load():
	var i = 0
	while(i < Globals.temp_entities.size()):
		Globals.destroyed_entities[Globals.map].remove(Globals.temp_entities[i])
		i += 1
	Globals.temp_entities.clear()
	for prop_name in Globals.player.keys():
		if (prop_name == "map"):
			continue
		set(prop_name, Globals.player[prop_name])
		print("Loading " + prop_name + str(Globals.player[prop_name]))

var start_layer
var start_mask
func _ready():
	start_layer = collision_layer
	start_mask = collision_mask
	rbar_step = $RetractBar.max_value / 20
	retract_step = throw_cooldown / 20
	if (Globals.player["global_position"] != Vector2.ZERO):
		checkpoint_load()
	set_hp(hp, max_hp)
	set_mana(mana, max_mana)
	start_scale = scale
	$RetractTimer.connect("timeout", self, "_on_retract_timeout")
	$ThrowTimer.connect("timeout", self, "_on_throw_timeout")
	$ChargeTimer.connect("timeout", self, "_on_progress_timeout")
	gui.switch_ability()

func _on_retract_timeout():
	$RetractBar.value += rbar_step
	if ($RetractBar.value >= $RetractBar.max_value):
		$RetractTimer.stop()
		$RetractBar.visible = false
		$RetractBar.value = 0

func _on_throw_timeout():
	print("can throw again")
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
	if (get_parent().wpaused):
		return
	mousepos = get_global_mouse_position()
	mouse_angle = rad2deg($MousePtr.get_angle_to(mousepos))
	if (mousepos.x > self.global_position.x):
    	turn_right()
	else:
    	turn_left()
	
	if event is InputEventMouseButton:
		if (event.is_pressed() && event.button_index == BUTTON_RIGHT && mana >= ability_cost && ability_name == "Fireball"):
			cast_fireball()
		if (event.is_pressed() && possessing && event.button_index == BUTTON_RIGHT):
			possess_revert()
		if (event.is_pressed() &&
		event.button_index == BUTTON_RIGHT &&
		ability_name == "Possess" &&
		mana >= ability_cost &&
		pos_queue):
			cast_pspell()
		if (event.is_pressed() && event.button_index == BUTTON_LEFT &&
		can_sword_attack &&
		can_throw && has_sword):
			$TextureProgress.visible = true
			$ChargeTimer.start()
		elif (can_throw &&	#kuldaun ne tolko na brosok, no i na vozvrat
		event.is_pressed() &&
		event.button_index == BUTTON_LEFT &&
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
	if (!dead && possessing):
		possess_revert(true)
	elif (!dead):
		visible = false
		dead = true
		Globals.score = money
		get_tree().change_scene("res://UI/Death.tscn")

var axis = Vector2.ZERO
var collision

var standing_on
var void_timeout = 0.75
var fade_time = 0.07
var standing_offset = Vector2(0, 30)
func _physics_process(delta):
	standing_on = (map.get_cellv(map.world_to_map(global_position + standing_offset)))
	if (standing_on == -1 && possessing):
		possess_revert()
	if (standing_on != -1 && !$VoidTimer.is_stopped()):
		print("No longer above the void")
		$FadeTimer.stop()
		$Sprite.modulate.a = 1
		$VoidTimer.stop()
	if (axis == Vector2.ZERO &&
	motion == Vector2.ZERO &&
	standing_on == -1 &&
	$VoidTimer.is_stopped()):
		print("Void timer start")
		$FadeTimer.start(fade_time)
		$VoidTimer.start(void_timeout)
	if (can_throw && !has_sword && $AnimationPlayer.current_animation != "RetractAnim"):
		$RetractAnim.show()
		$AnimationPlayer.play("RetractAnim")
	if (hp < 1):
		die()
	if (!dead && !knock_baking):
		axis = direction()
	if (!knock_baking && !can_walk):
		axis = Vector2.ZERO
	
	if (knock_baking):
		axis = knock_dir
		thrust -= knock_resistance
		if (!possessing && thrust <= thrust_v):
			thrust = thrust_v
			knock_resistance = knock_resistance_v
			knock_baking = false
			speed_max = speed_max_v
		if (possessing && thrust <= thrust_p):
			thrust = thrust_p
			knock_resistance = knock_resistance_p
			knock_baking = false
			speed_max = speed_max_p
	
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
		aim_vertical = 0

func _on_AimDown_area_entered(area):
	if (area.has_method("mouseptr")):
		aim_vertical = 1

func _on_AimUp_area_exited(area):
	if (area.has_method("mouseptr")):
		aim_vertical = -1

func _on_AimDown_area_exited(area):
	if (area.has_method("mouseptr")):
		aim_vertical = -1

func _on_VoidTimer_timeout():
	if (standing_on == -1):
		die()
	print("Bruh")
	$VoidTimer.stop()
	$FadeTimer.stop()

func _on_FadeTimer_timeout():
	var amt = 0.1
	if ($Sprite.modulate.a - amt > 0):
		$Sprite.modulate.a -= amt

var pos_queue = false #possession queue (to select only one mob)
var pos_body
func _on_MouseArea_body_entered(body):
	if (ability_name == "Possess" &&
	mana >= ability_cost &&
	!pos_queue &&
	body.has_method("mob") &&
	body.possessable):
		body.get_node("Possession/PossessionLabel").visible = true
		pos_queue = true
		pos_body = body

func _on_MouseArea_body_exited(body):
	if (body.has_method("mob") && body.possessable && body == pos_body):
		body.get_node("Possession/PossessionLabel").visible = false
		pos_queue = false
