extends RigidBody2D

var on_floor = false
var bouncing = false
var bounce_timeout = 0.5
var speed_cap = Vector2(5, 5)

	

# Called when the node enters the scene tree for the first time.
func _ready():
	$BounceTimer.connect("timeout", self, "_on_bounce_timeout")
	
	

func _on_bounce_timeout():
	print("Sword stopped bouncing")
	bouncing = false
	$BounceTimer.stop()

func drop():
	mode = MODE_STATIC
	on_floor = true
	print("Sword dropped")

func pick():
	pass
	
	# Upgrade fucking sword
func upgrade(upgrade):
	if upgrade == "f":   # Fire upgrade
		linear_velocity.x += 600	

func _physics_process(delta):
	if (abs(linear_velocity.x) < abs(speed_cap.x) || abs(linear_velocity.y) < abs(speed_cap.y) && !on_floor && !bouncing):
		drop()

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
		
	
