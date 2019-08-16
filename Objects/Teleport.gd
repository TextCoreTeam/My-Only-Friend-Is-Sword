extends Area2D

export var scene_name = ""

func _ready():
	pass

func _on_Teleport_body_entered(body):
	if (body.has_method("pdmg")):
		get_tree().change_scene("res://Maps/" + scene_name)
