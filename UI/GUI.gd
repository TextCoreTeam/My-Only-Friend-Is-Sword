extends CanvasLayer

var ability = ["Possess"]
var cost = [5]
var ability_current = 0
onready var ability_count = ability.size()

func add_ability(id):
	ability.append(Globals.ability_list[id])
	cost.append(Globals.cost_list[id])
	ability_count = ability.size()
	switch_ability()

func switch_ability():
	if (ability_current < 0):
		ability_current = ability_count - 1
	if (ability_current >= ability_count):
		ability_current = 0
	$AbilityBox/Label.text = ability[ability_current]
	$AbilityBox/AbilityBar.max_value = cost[ability_current]
	$AbilityBox/AbilityBar.value = player.mana
	$AbilityBox/AbilityBar.update()
	player.ability_current = ability_current
	player.ability_name = ability[ability_current]
	player.ability_cost = cost[ability_current]

func _input(event):
	if (world.wpaused || player.possessing || player.cast_tutorial):
		print("bruh input")
		return
	if (event is InputEventMouseButton && event.is_pressed()):
			if (event.button_index == BUTTON_WHEEL_UP):
				ability_current += 1
			if (event.button_index == BUTTON_WHEEL_DOWN):
				ability_current -= 1
			switch_ability()

onready var world = get_parent()
var player
func _ready():
	player = world.get_node("Player")
	$AbilityBox.modulate.a = 0.5

#func _process(delta):
#	pass