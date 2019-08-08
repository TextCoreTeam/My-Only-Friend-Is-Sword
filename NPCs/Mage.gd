extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob = get_parent()
	mob.hp = 3
	mob.damage_amount = 2
	mob.melee_cooldown = 2
	mob.speed = 10
	mob.has_range_attack = true
	mob.bullet_speed = 7
	mob.has_melee_attack = true
	mob.visibility_dst = 500
	mob.lose_dst = 2000
	mob.attack_frame = 0.8
	mob.knock_maxspeed = 1000
	mob.knock_thrust = 3000
	mob.bullet_type = 0
	mob.reward = 2
	mob.shake_amt = 7

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
