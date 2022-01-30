extends Node2D

onready var game : Game = $Game


func _ready():
	randomize()

	game.build_game(preload("res://core/schematics/Una.tres"), 2)
	build_event_queue(game.event_queue)
	game.start()


func _on_Game_queue_finished():
	print("game finished")


func build_event_queue(queue : EventQueue):
	var factory := EventFactory.new()
	
	var play_pile : Pile = GameState.piles["play"]
	var draw_pile : Pile = GameState.piles["draw"]
	
	queue.map(factory.build_pile(draw_pile))
	queue.map(factory.shuffle_pile(draw_pile))
	queue.map(factory.deal_cards(draw_pile, 5))
	queue.map(factory.move_top_card(draw_pile, play_pile, true))

	var play_loop := factory.event_queue("PlayLoop", 0)
	queue.map(play_loop)
	
	var draw_cards := factory.draw_cards(0, draw_pile)
	play_loop.map(factory.play_cards(0, play_pile, draw_cards))
	
	var break_queue := factory.break_queue(play_loop)
	play_loop.map(factory.check_player_hand_empty(0, break_queue))

	play_loop.map(factory.next_turn())
