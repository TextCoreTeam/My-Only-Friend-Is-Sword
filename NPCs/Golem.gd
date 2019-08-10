extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 8
	mob.damage_amount = 2
	mob.melee_cooldown = 1.75
	mob.speed = 70
	mob.knock_speed = 20
	mob.knock_speed_damp = 0.9
	mob.knock_time = 0.15
	mob.has_range_attack = false
	mob.bullet_speed = 0
	mob.has_melee_attack = true
	mob.visibility_dst = 450
	mob.lose_dst = 2000
	mob.attack_frame = 0.8
	mob.knock_maxspeed = 3000
	mob.knock_thrust = 6000
	mob.reward = 3
	mob.shake_amt = 25