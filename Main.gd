extends Node2D

onready var game : Game = $Una


func _ready():
	randomize()
	
	game.connect("queue_finished", self, "_on_Game_queue_finished")
	game.start()


func _on_Game_queue_finished():
	print("game finished")
