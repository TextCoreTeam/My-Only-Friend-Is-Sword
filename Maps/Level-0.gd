extends Node2D

func _ready():
	var level = get_parent()
	level.name_str = "Shit from the ass"
	level.update_map_name()
	pass
	
func update_score(points):
	$GUI/score.text = "Score: "+str(points)