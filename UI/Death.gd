extends Control

var action
func _ready():
	var scorelbl = $CenterContainer/MenuCol/VSplitContainer/ScoreLbl
	var check = $CenterContainer/MenuCol/GameBtnContainer/VBoxContainer/CheckpBtn
	if (Globals.game_mode == 0):
		scorelbl.visible = false
	if (Globals.game_mode == 1 || Globals.checkpoint() == Vector2.ZERO):
		check.visible = false
	scorelbl.text = "Score: " + str(Globals.score)
	pass

func _on_NewGameBtn_pressed():
	print(get_tree().change_scene("res://UI/Menu.tscn"))

func _on_ContinueBtn_pressed():
	get_tree().quit()

func _on_CheckpBtn_pressed():
	action = "checkpoint"
	$AnimationPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if (action == "checkpoint"):
		print(get_tree().change_scene(Globals.player["map"]))
