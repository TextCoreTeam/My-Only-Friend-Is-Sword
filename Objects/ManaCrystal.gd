extends Area2D

func _ready():
	pass

func _on_ManaCrystal_body_entered(body):
	if (body.has_method("pdmg")):
		body.add_mana()
		queue_free()