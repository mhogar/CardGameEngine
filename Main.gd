extends Node2D

onready var game : Game = $Una
onready var replay_menu := $CanvasLayer/ReplayMenu


func _ready():
	randomize()
	
	game.connect("game_finished", self, "_on_Game_finished")
	game.start()


func _on_Game_finished():
	replay_menu.show()


func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	game.reset()
	game.start()
