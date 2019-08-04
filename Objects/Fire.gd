extends Area2D


func _ready():
	pass # Replace with function body.


func _on_Fire_body_entered(body):
	if (body.has_method("upgrade")):
		body.upgrade("f")   #Fire upgrade
	