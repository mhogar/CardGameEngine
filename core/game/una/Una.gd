extends Game
class_name UnaGame


func _ready():
	init_game()
	build_event_queue()
	start()


func init_scoreboard():
	game_ctx.add_player_score("Score")


func build_event_queue():
	var factory := EventFactory.new()
	
	var play_pile : Pile = game_ctx.piles["play"]
	var draw_pile : Pile = game_ctx.piles["draw"]
	
	game_loop.map(factory.build_pile(draw_pile, StandardDeckBuilder.new()))
	game_loop.map(factory.shuffle_pile(draw_pile))
	game_loop.map(factory.deal_cards(game_ctx.players, draw_pile, 5))
	game_loop.map(factory.move_top_card(draw_pile, play_pile))

	var play_loop := factory.event_queue("PlayLoop", 0)
	game_loop.map(play_loop)
	
	var reshuffle_draw_pile := factory.reshuffle_pile(draw_pile, play_pile)
	var draw_cards := factory.draw_cards(0, draw_pile, reshuffle_draw_pile)
	
	var remove_player := factory.remove_player(0)
	play_loop.map(factory.play_cards(0, play_pile, UnaRuleset.new(), draw_cards, remove_player))

	var break_queue := factory.break_queue(play_loop)
	play_loop.map(factory.players_left_condition(break_queue, 1))

	play_loop.map(factory.next_turn())
