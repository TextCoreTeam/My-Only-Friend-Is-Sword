extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameBtn_pressed():
	print(get_tree().change_scene("res://Maps/Level-0.tscn"))


func _on_ContinueBtn_pressed():
	pass # Replace with function body.


func _on_QuitBtn_pressed():
	get_tree().quit()
