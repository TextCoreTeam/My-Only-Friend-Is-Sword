extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 3
	mob.damage_amount = 1
	mob.melee_cooldown = 1.7
	mob.speed = 30
	mob.has_range_attack = false
	mob.bullet_speed = 7
	mob.has_melee_attack = true
	mob.visibility_dst = 500
	mob.lose_dst = 2000
	mob.attack_frame = 0.8
	mob.knock_maxspeed = 3000
	mob.knock_thrust = 6000
	#mob.bullet_type = 0