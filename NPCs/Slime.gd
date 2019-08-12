extends Sprite

func _ready():
	var mob = get_parent()
	mob.hp = 2
	mob.damage_amount = 1
	mob.melee_cooldown = 1.7
	mob.speed = 35
	mob.knock_speed = 30
	mob.knock_speed_damp = 0.9
	mob.knock_time = 0.15
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
	mob.mana_drop = 1
	mob.possessable = true
	#Possession properties
	mob.p_sprite = "Slime_S"
	mob.p_thrust = 150
	mob.p_maxspeed = 150
	mob.p_walk = true
	mob.p_hp = 2
	mob.p_idle_anim = "SlimeMoveLR"
	mob.p_resist = 200
	#mob.bullet_type = 0