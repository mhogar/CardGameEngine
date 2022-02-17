extends Game
class_name UnaGame


func _ready():
	init_game_state()
	build_event_queue()


func build_event_queue():
	var factory := EventFactory.new()
	
	var play_pile : Pile = GameState.piles["play"]
	var draw_pile : Pile = GameState.piles["draw"]
	
	game_loop.map(factory.build_pile(draw_pile))
	game_loop.map(factory.shuffle_pile(draw_pile))
	game_loop.map(factory.deal_cards(draw_pile, 5))
	game_loop.map(factory.move_top_card(draw_pile, play_pile))

	var play_loop := factory.event_queue("PlayLoop", 0)
	game_loop.map(play_loop)
	
	var draw_cards := factory.draw_cards(0, draw_pile)
	play_loop.map(factory.play_cards(0, play_pile, draw_cards))
	
	var break_queue := factory.break_queue(play_loop)
	play_loop.map(factory.check_player_hand_empty(0, break_queue))

	play_loop.map(factory.next_turn())
