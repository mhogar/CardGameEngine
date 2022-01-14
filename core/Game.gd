extends Node

onready var game_builder := $GameBuilder

onready var human := $Table/Human
onready var ai := $Table/AI

onready var play_pile := $Table/PlayPile
onready var draw_pile := $Table/DrawPile


func _ready():
	game_builder.create_deck(draw_pile, 30)
	
	var num_cards := 10
	game_builder.create_deck(human.hand, num_cards, true)
	game_builder.create_deck(ai.hand, num_cards)
	
	for i in 5:
		game_builder.draw_card(human, draw_pile)
		game_builder.play_card(human, play_pile)
		
		game_builder.draw_card(ai, draw_pile)
		game_builder.play_card(ai, play_pile)
	
	game_builder.start_queue()


func _on_GameBuilder_queue_finished():
	print("game finished")
