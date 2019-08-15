extends Area2D

export (String, MULTILINE) var text
export var oneshot = false
var triggered = false

func _ready():
	pass

func _on_DialogTrigger_body_entered(body):
	if (body.has_method("pdmg")):
		get_parent().show_msg(text)
		triggered = true
		if (oneshot):
			Globals.remove_from_map(get_path())
			queue_free()