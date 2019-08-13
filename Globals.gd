extends Node
# Temp values
var game_mode	#0 -- story || 1 -- arcade
var player_pause = false

# Global and saveable values
var score #to save score between the scenes
var last_level = ""
var checkpoint = Vector2.ZERO
var player_ability = []
var player_ability_cost = []

# Lists n shit
var ability_list = 	["Fireball", 	"Blink", 	"Possess"]
var cost_list = 	[1, 			3, 			5]

func reset_player():
	score = 0
	last_level = ""
	checkpoint = Vector2.ZERO
	player_ability = []
	player_ability_cost = []

func _ready():
	pass