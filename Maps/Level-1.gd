extends Sprite

func _ready():
	var level = get_parent()
	level.name_str = ""
	level.save_state = true
	level.update_map_name()
	level.show_exp = false