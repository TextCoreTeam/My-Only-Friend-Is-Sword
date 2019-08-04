extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var in_zone = false
var player
func _physics_process(delta):
	if (in_zone && player.motion == Vector2.ZERO && player.axis == Vector2.ZERO):
		player.die()	



func _on_Death_zone_body_entered(body):
	if body.has_method("pdmg"):
		player = body
		in_zone = true


func _on_Death_zone_body_exited(body):
	if body.has_method("pdmg"):
		player = body
		in_zone = false