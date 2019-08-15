extends Node
# Temp values
var game_mode	#0 -- story || 1 -- arcade
var player_pause = false

# Global and saveable values
var score #to save score between the scenes (arcade)
var map = ""
var player = {	"x" : 0,
				"y" : 0, 
				"map" : "", 
				"hp" : 0, 
				"max_hp" : 0, 
				"mana" : 0, 
				"max_mana" : 0,
				"xp" : 0,
				"required_xp" : 0,
				"lvl" : 0
				}
var destroyed_entities = {"" : []} #shit for destroyed static entities
var temp_entities = [] #destroyed before checkpoint
var player_ability = []
var player_ability_cost = []

# Lists n shit
var ability_list = 	["Fireball", 	"Blink", 	"Possess"]
var cost_list = 	[1, 			3, 			5]

func checkpoint():
	return Vector2(player["x"], player["y"])

func reset_player():
	score = 0
	player["x"] = 0
	player["y"] = 0
	player_ability = []
	player_ability_cost = []

const savefile = "user://mofis_save.dat"

var saveable_objects = [	"player", "player_ability", "player_ability_cost",
							"destroyed_entities"
							]

func save_game():
	var save_game = File.new()
	save_game.open(savefile, File.WRITE)
	var i = 0
	while (i < saveable_objects.size()):
		print("serializing " + str(get(saveable_objects[i])))
		save_game.store_line(to_json(get(saveable_objects[i])))
		i += 1
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(savefile):
		return false
	print(savefile)
	save_game.open(savefile, File.READ)
	var i = 0
	while (i < saveable_objects.size()):
		var data = parse_json(save_game.get_line())
		if (typeof(data) == TYPE_DICTIONARY):
			for prop_name in data.keys():
				print("Loading " + prop_name + ": " + str(data[prop_name]))
				if (typeof(data[prop_name]) == TYPE_ARRAY):
					get(saveable_objects[i])[prop_name] = []
					var k = 0
					while (k < data[prop_name].size()):
						get(saveable_objects[i])[prop_name].append(data[prop_name][k])
						k += 1
				else:
					get(saveable_objects[i])[prop_name] = data[prop_name]
				#player[prop_name] 
		elif (typeof(data) == TYPE_ARRAY):
			get(saveable_objects[i]).clear()
			var j = 0
			while (j < data.size()):
				get(saveable_objects[i]).append(data[j])
				j += 1
		i += 1
	save_game.close()
	return true

func remove_from_map(name):
		if (!Globals.destroyed_entities.has(Globals.map)):
			print("Creating map destroyed obj list")
			Globals.destroyed_entities[Globals.map] = []
		Globals.destroyed_entities[Globals.map].append(name)
		Globals.temp_entities.append(Globals.destroyed_entities[Globals.map].back())

func _ready():
	pass