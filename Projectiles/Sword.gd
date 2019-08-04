extends RigidBody2D

var on_floor = false
var bouncing = false
var bounce_timeout = 0.5
var speed_cap = Vector2(0.5, 0.5)
var knock_speed_max = 2000
var knock_thrust = 4000
var upgraded = ""
var dmg_num = 1

var player
func _ready():
	player = get_parent().get_parent().get_node("Player")
	$BounceTimer.connect("timeout", self, "_on_bounce_timeout")
	self.add_collision_exception_with(player)
	$TransparentTimer.connect("timeout", self, "_on_transparency_timeout")
	$TransparentTimer.start(0.13)
	
func _on_transparency_timeout():
	self.remove_collision_exception_with(player)

func _on_bounce_timeout():
	print("Sword stopped bouncing")
	bouncing = false
	$BounceTimer.stop()

func drop():
	mode = MODE_STATIC
	on_floor = true
	knock_speed_max = 2000
	knock_thrust = 4000
	upgraded = ""
	dmg_num = 1
	#print("Bruh moment")
	#queue_free()

func pick():
	pass
	
	# Upgrade fucking sword
var fire_upgrade = 3
func upgrade(upgrade):
	if upgrade == "f":   # Fire upgrade
		linear_velocity *= fire_upgrade
		upgraded = "f"
		knock_speed_max = 3000
		knock_thrust = 6000
		



func return_velocity():
	return (player.get_global_position() - get_global_position()).normalized() * player.sword_speed

func _physics_process(delta):
	if (abs(linear_velocity.x) < abs(speed_cap.x) || abs(linear_velocity.y) < abs(speed_cap.y) && !on_floor && !bouncing):
		drop()
	if (bouncing):
		linear_velocity = return_velocity()

func _on_RigidBody2D_body_entered(body):

	if (body.has_method("mob") && !on_floor && body.can_take_dmg):
		if upgraded == "f":
			dmg_num = 2
			print(dmg_num)
		body.dmg(dmg_num)

	if (body.has_method("pdmg")):
		body.knockback((-1) * return_velocity(), knock_speed_max, knock_thrust)
		body.return_sword()
		queue_free()
		
	if (body.has_method("dest_on_col")):
		body.queue_free()


	if (!bouncing):
		print("Sword is bouncing")
		bouncing = true
		$BounceTimer.start(bounce_timeout)
		
	
