extends KinematicBody2D

var velocity = Vector2()

func _on_timer_timeout():
	queue_free()

func dmg():
	queue_free()

func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start()
	pass
	
func dest_on_col():
	pass

var collision

func _physics_process(delta):
	collision = move_and_collide(velocity)
	if (collision && collision.collider.has_method("pdmg")):
		collision.collider.dmg(1)
		queue_free()
	elif (collision && collision.collider.has_method("odmg")):
		collision.collider.odmg()
		queue_free()
	elif (collision):
		queue_free()