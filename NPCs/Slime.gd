extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 2
	mob.damage_amount = 1
	mob.melee_cooldown = 1.7
	mob.speed = 35
	mob.has_range_attack = false
	mob.bullet_speed = 7
	mob.has_melee_attack = true
	mob.visibility_dst = 500
	mob.lose_dst = 2000
	mob.attack_frame = 0.8
	mob.knock_maxspeed = 1000
	mob.knock_thrust = 3000
	mob.reward = 1
	mob.shake_amt = 5
	#mob.bullet_type = 0