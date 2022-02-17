extends Node2D

onready var game := $Una


func _ready():
	randomize()
	game.start()


func _on_Game_queue_finished():
	print("game finished")
