extends Area2D

export var scene_name = ""

onready var gui = get_parent().get_node("GUI")
func _ready():
	pass

func _on_Teleport_body_entered(body):
	if (body.has_method("pdmg")):
		gui.fade_in()
		$Timer.start(0.8)


func _on_Timer_timeout():
	get_tree().change_scene("res://Maps/" + scene_name)