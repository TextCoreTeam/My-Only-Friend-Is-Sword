extends Control
var game_start = preload("res://Maps/Level-0.tscn")
var action
func _ready():
	#print("Savefile exists: " + str(Globals.load_game()))
	$VerLbl.text = Globals.version
	pass

func _on_NewGameBtn_pressed():
	Globals.game_mode = 0
	action = "newgame"
	$AnimationPlayer.play("FadeIn")

func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_ArcadeBtn_pressed():
	Globals.game_mode = 1
	action = "arcade"
	$AnimationPlayer.play("FadeIn")


func _on_ContBtn_pressed():
	if (Globals.load_game()):
		action = "continue"
		Globals.game_mode = 0
		$AnimationPlayer.play("FadeIn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if (action == "newgame"):
		Globals.reset_player()
		get_tree().change_scene_to(game_start)
	elif (action == "continue"):
		get_tree().change_scene(Globals.player["map"])
	elif (action == "arcade"):
		get_tree().change_scene("res://Maps/Level-Arcade.tscn")
