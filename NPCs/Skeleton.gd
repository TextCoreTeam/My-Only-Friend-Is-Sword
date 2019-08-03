extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 4
	mob.damage_amount = 2
	mob.melee_cooldown = 1
	mob.speed = 120
	mob.has_range_attack = false
	mob.bullet_speed = 0
	mob.has_melee_attack = true
	mob.visibility_dst = 300
	mob.lose_dst = 2000