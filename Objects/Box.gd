extends KinematicBody2D

var hp = 5

func _ready():
	pass
	
func dmg():
	hp -= 1
	$Sprite.frame += 1

func _physics_process(delta):
	if (hp < 1):
		queue_free()
