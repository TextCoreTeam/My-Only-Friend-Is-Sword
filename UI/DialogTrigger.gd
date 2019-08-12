extends Area2D

export (String, MULTILINE) var text
export var oneshot = false
var triggered = false

func _ready():
	pass

func _on_DialogTrigger_body_entered(body):
	if (body.has_method("pdmg")):
		if (oneshot && triggered):
			return
		get_parent().show_msg(text)
		triggered = true