extends Node2D

onready var game : Game = $Game


func _ready():
	create_game()
	game.start()


func create_game():
	var table := game.table
	
	var human := table.human_player
	var ai := table.add_new_AI_player()
	
	var play_pile := table.add_new_pile(Vector2(-0.5, 0.0))
	var draw_pile := table.add_new_pile(Vector2(0.5, 0.0))
	draw_pile.build(52)
	
	table.finalize(get_viewport().size)

	game.event_queue.deal_cards(table.players, draw_pile, 5)

	var play_loop := game.event_queue.sub_queue("PlayLoop", Event.EventType.MAP, 5)
	
	play_loop.draw_cards(human, draw_pile)
	play_loop.play_cards(human, play_pile)
		
	play_loop.draw_cards(ai, draw_pile)
	play_loop.play_cards(ai, play_pile)


func _on_Game_queue_finished():
	print("game finished")
