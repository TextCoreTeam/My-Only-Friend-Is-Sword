extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("onmobdeath!111111")



func _on_Timer_timeout():
	print("Cleaning up death particles...")
	queue_free()
