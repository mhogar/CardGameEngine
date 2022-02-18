extends Node2D

onready var game : Game = $Una


func _ready():
	randomize()
	
	game.connect("game_finished", self, "_on_Game_finished")
	game.start()


func _on_Game_finished():
	print("game finished")
