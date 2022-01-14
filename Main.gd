extends Node2D

onready var game : Game = $Game


func _ready():
	create_game()
	game.start()


func create_game():
	var table := game.table
	
	var human := table.human_player
	human.hand.build(10, true)
	
	var ai := table.add_new_AI_player()
	ai.hand.build(10)
	
	var play_pile := table.add_new_pile()
	var draw_pile := table.add_new_pile()
	draw_pile.build(30)
	
	table.finalize()

	var builder := game.builder
	for i in 5:
		builder.draw_card(human, draw_pile)
		builder.play_card(human, play_pile)
		
		builder.draw_card(ai, draw_pile)
		builder.play_card(ai, play_pile)	


func _on_Game_queue_finished():
	print("game finished")
