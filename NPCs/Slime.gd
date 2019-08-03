extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 2
	mob.melee_cooldown = 1
	mob.damage_amount = 1
	mob.speed = 100
	mob.has_range_attack = true
	mob.bullet_speed = 6
	mob.has_melee_attack = true
	mob.visibility_dst = 300
	mob.lose_dst = 1500
	mob.attack_frame = 0.8