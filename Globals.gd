extends Node
# Temp values
var game_mode	#0 -- story || 1 -- arcade
var player_pause = false

# Global and saveable values
var score #to save score between the scenes (arcade)
var map = ""
var player = {	"global_position" : Vector2.ZERO, 
				"map" : "", 
				"hp" : 0, 
				"max_hp" : 0, 
				"mana" : 0, 
				"max_mana" : 0
				}
var destroyed_entities = {"" : []} #shit for destroyed static entities
var player_ability = []
var player_ability_cost = []

# Lists n shit
var ability_list = 	["Fireball", 	"Blink", 	"Possess"]
var cost_list = 	[1, 			3, 			5]

func reset_player():
	score = 0
	player["global_position"] = Vector2.ZERO
	player_ability = []
	player_ability_cost = []

func _ready():
	pass