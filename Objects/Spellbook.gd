extends Area2D

export var spell_name = "Possess"
export var number = 0

func _ready():
	$Sprite.frame = number
	pass


func _on_Spellbook_body_entered(body):
	if (body.has_method("pdmg")):
		body.unlock_ability(spell_name)
		get_parent().show_msg("New spell unlocked: " + spell_name + "!")
		queue_free()
