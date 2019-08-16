extends CanvasLayer

var ability_current = 0
onready var ability_count = Globals.player_ability.size()

func add_ability(id):
	if (Globals.player_ability.has(Globals.ability_list[id])
	|| id >= Globals.ability_list.size()):
		return
	Globals.player_ability.append(Globals.ability_list[id])
	Globals.player_ability_cost.append(Globals.cost_list[id])
	ability_count = Globals.player_ability.size()
	switch_ability()

func switch_ability():
	ability_count = Globals.player_ability.size()
	if (ability_count == 0):
		$AbilityBox.visible = false
		return
	else:
		if (!$AbilityBox.visible):
			$AbilityBox.visible = true
	if (ability_current < 0):
		ability_current = ability_count - 1
	if (ability_current >= ability_count):
		ability_current = 0
	$AbilityBox/Label.text = Globals.player_ability[ability_current]
	$AbilityBox/AbilityBar.max_value = Globals.player_ability_cost[ability_current]
	$AbilityBox/AbilityBar.value = player.mana
	$AbilityBox/AbilityBar.update()
	player.ability_current = ability_current
	player.ability_name = Globals.player_ability[ability_current]
	player.ability_cost = Globals.player_ability_cost[ability_current]

func _input(event):
	if (world.wpaused || player.possessing):
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
	$ExpBar.modulate.a = 0.6
	$AbilityBox.modulate.a = 0.5

func _process(delta):
	if (world.wpaused && $ExpBar.visible):
		$ExpBar.visible = false
	if (!world.wpaused && !$ExpBar.visible && Globals.game_mode == 0 && world.show_exp):
		$ExpBar.visible = true