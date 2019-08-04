extends RigidBody2D

var on_floor = false
var bouncing = false
var bounce_timeout = 0.5
var speed_cap = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
var player
func _ready():
	player = get_parent().get_parent().get_node("Player")
	$BounceTimer.connect("timeout", self, "_on_bounce_timeout")
	
	

func _on_bounce_timeout():
	print("Sword stopped bouncing")
	bouncing = false
	$BounceTimer.stop()

func drop():
	mode = MODE_STATIC
	on_floor = true
	print("Bruh moment")
	queue_free()

func pick():
	pass
	
	# Upgrade fucking sword
var fire_upgrade = 3
func upgrade(upgrade):
	if upgrade == "f":   # Fire upgrade
		linear_velocity *= fire_upgrade

func _physics_process(delta):
	if (abs(linear_velocity.x) < abs(speed_cap.x) || abs(linear_velocity.y) < abs(speed_cap.y) && !on_floor && !bouncing):
		drop()
	if (bouncing):
		linear_velocity = (player.get_global_position() - get_global_position()).normalized() * player.sword_speed

func _on_RigidBody2D_body_entered(body):

	if (body.has_method("mob") && !on_floor && body.can_take_dmg):
		body.dmg()

	if (body.has_method("pdmg") && !on_floor):
		body.knockback(linear_velocity, body.sword_knock_speed_max, body.sword_knock_thrust)
	
	if (body.has_method("pdmg")): #&& on_floor):
		body.return_sword()
		queue_free()


	if (!bouncing):
		print("Sword is bouncing")
		bouncing = true
		$BounceTimer.start(bounce_timeout)
		
	
