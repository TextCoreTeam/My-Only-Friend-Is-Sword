extends Node2D

func _ready():
	var level = get_parent()
	level.name_str = ""
	level.update_map_name()
	level.show_msg("Press LMB to throw the sword; Press LMB to bring your sword back; As you can see, you can move just by throwing your sword; Try to not to fall down; Be aware of enemies! Good luck")
	pass
	
func update_score(points):
	$GUI/score.text = "Score: "+str(points)