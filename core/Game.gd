extends Node

onready var game_builder := $GameBuilder

onready var player := $Controllers/Player
onready var ai := $Controllers/AI

onready var player_hand := $Table/PlayerHand
onready var ai_hand := $Table/AIHand
onready var play_pile := $Table/PlayPile
onready var draw_pile := $Table/DrawPile


func _ready():
	game_builder.create_deck(draw_pile, 30)
	
	var num_cards := 10
	game_builder.create_deck(player_hand, num_cards)
	game_builder.create_deck(ai_hand, num_cards)
	
	for i in 5:
		game_builder.draw_card(player, draw_pile)
		game_builder.play_card(player, play_pile)
		
		game_builder.draw_card(ai, draw_pile)
		game_builder.play_card(ai, play_pile)
	
	game_builder.start_queue()


func _on_GameBuilder_queue_finished():
	print("game finished")
