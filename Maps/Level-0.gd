extends Node2D
func _ready():
	var level = get_parent()
	level.show_exp = false
	level.save_state = true
	level.name_str = "Shadow Realm\nPart 1"
	if (Globals.checkpoint() == Vector2.ZERO):
		level.get_node("GUI").fade_out("Prologue", level.name_str)
		Globals.reset_player()
		level.get_node("GUI").switch_ability()
		level.show_msg_delayed(" Press RMB to proceed.; " + 
		" You wake up in a strange place surrounded by deafening silence...;" +
		" Thinking you've been robbed, you nervously check your pockets...;" +
		" ...and realize you have no hands or legs.; Finally, you understand that you are a ghost now.;" +
		" And this place most likely is the Shadow Realm, as the legends say.;" +
		" Suddenly, a very clear image of a glowing sword...; ...appears in your mind.;" +
		" Press LMB to throw the sword.; Press LMB again to bring your sword back.; You realize you can move only by throwing your sword.; Time to go!", 1)