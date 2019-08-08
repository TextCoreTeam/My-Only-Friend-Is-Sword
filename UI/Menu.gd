extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var globals
func _ready():
	globals = get_node("/root/Globals")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameBtn_pressed():
	globals.game_mode = 0
	get_tree().change_scene("res://Maps/Level-0.tscn")
	


func _on_ContinueBtn_pressed():
	globals.game_mode = 1
	get_tree().change_scene("res://Maps/TestMap.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()
