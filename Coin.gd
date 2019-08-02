extends KinematicBody2D

var velocity = Vector2.ZERO
var collision

func _physics_process(delta):
	collision = move_and_collide(velocity)
	if collision && collision.collider.has_method("p_inc"):
		collision.collider.p_inc()
		queue_free()