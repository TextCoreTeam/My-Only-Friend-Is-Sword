extends Node

var game_mode	#0 -- story || 1 -- arcade
var score #to save score between the scenes
var player_pause = false
var checkpoint = Vector2.ZERO

var ability_list = 	["Fireball", 	"Blink", 	"Possess"]
var cost_list = 	[1, 			3, 			5]

func _ready():
	pass