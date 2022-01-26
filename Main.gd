extends Node2D

onready var game : Game = $Game
onready var factory : EventFactory = $EventFactory

var schematic : GameSchematic = preload("res://core/schematics/Una.tres")


func _ready():
	randomize()
	create_game()
	game.start()


func create_game():
	setup_table(game.table, 2)
	build_event_queue(game.event_queue)
	

func setup_table(table : Table, num_players : int):
	for i in range(1, num_players):
		table.add_new_AI_player()
	
	for key in schematic.table:
		table.add_new_pile(key, schematic.table[key])
	
	table.finalize(get_viewport().size)
	

func build_event_queue(queue : EventQueue):
	var players := GameState.players
	var play_pile : Pile = GameState.piles["play"]
	var draw_pile : Pile = GameState.piles["draw"]
	
	queue.map(factory.build_pile(draw_pile))
	queue.map(factory.shuffle_pile(draw_pile))
	queue.map(factory.deal_cards(players, draw_pile, 5))
	queue.map(factory.move_top_card(play_pile, true))

	var play_loop := factory.event_queue("PlayLoop", 0)
	queue.map(play_loop)
	
	for player in players:
		var draw_cards := factory.draw_cards(player, draw_pile)
		play_loop.map(factory.play_cards(player, play_pile, draw_cards))
		
		var break_queue := factory.break_queue(play_loop)
		play_loop.map(factory.check_deck_empty(player.hand, break_queue))


func _on_Game_queue_finished():
	print("game finished")
