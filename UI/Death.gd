extends Control

var globals
func _ready():
	var scorelbl = $CenterContainer/MenuCol/VSplitContainer/ScoreLbl
	var check = $CenterContainer/MenuCol/GameBtnContainer/VBoxContainer/CheckpBtn
	globals = get_node("/root/Globals")
	if (globals.game_mode == 0):
		scorelbl.visible = false
	if (globals.game_mode == 1 || Globals.checkpoint() == Vector2.ZERO):
		check.visible = false
	scorelbl.text = "Score: " + str(globals.score)
	pass

func _on_NewGameBtn_pressed():
	print(get_tree().change_scene("res://UI/Menu.tscn"))

func _on_ContinueBtn_pressed():
	get_tree().quit()

func _on_CheckpBtn_pressed():
	print(get_tree().change_scene(Globals.player["map"]))
