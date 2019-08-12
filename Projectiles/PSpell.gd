extends Area2D

func _ready():
	pass

func _process(delta):
	pass


func _on_PSpell_body_entered(body):
	if (body.has_method("mob") && body.possessable):
		get_parent().possess()
		queue_free()
