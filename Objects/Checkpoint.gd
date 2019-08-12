extends Area2D

func _ready():
	pass

func object_passable():
	pass

func _on_Area2D_body_entered(body):
	if (body.has_method("pdmg") && $Sprite.frame < 1):
		get_node("/root/Globals").checkpoint = global_position
		$Sprite.frame += 1