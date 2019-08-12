extends KinematicBody2D

var velocity = Vector2()

func _on_timer_timeout():
	queue_free()

func dmg():
	queue_free()

func _ready():
	add_collision_exception_with(get_parent().get_parent().get_node("Player"))
	add_collision_exception_with(get_parent().get_parent().get_node("PhysicalLayer"))
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start()
	pass

var collision

func _physics_process(delta):
	collision = move_and_collide(velocity)
	if (collision && collision.collider.has_method("dmg")):
		collision.collider.dmg(2)
		queue_free()
	elif (collision):
		print(collision.collider.name)
		queue_free()