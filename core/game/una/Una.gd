extends Game
class_name UnaGame


func _ready():
	init_game()
	build_event_queue()
	start()


func init_scoreboard():
	game_ctx.add_player_score("Score")
	

func create_ai_controller() -> Node:
	return preload("res://core/game/una/UnaAIController.tscn").instance()


func build_event_queue():
	var factory := EventFactory.new()
	var scripts := UnaScripts.new()
	
	var play_pile : Pile = game_ctx.piles["Play Pile"]
	var draw_pile : Pile = game_ctx.piles["Draw Pile"]
	
	game_loop.map(factory.build_pile(draw_pile, StandardDeckBuilder.new()))
	game_loop.map(factory.shuffle_pile(draw_pile))
	game_loop.map(factory.deal_cards(game_ctx.players, "Hand", draw_pile, 5))
	game_loop.map(factory.move_top_card(draw_pile, play_pile))

	var play_loop := factory.event_queue("PlayLoop", 0)
	game_loop.map(play_loop)
	
	var reshuffle_draw_pile := factory.reshuffle_pile(draw_pile, play_pile)
	var draw_cards := factory.draw_cards(0, "Hand", draw_pile, reshuffle_draw_pile)
	
	var player_out := factory.event_queue("PlayerOut")
	player_out.merge(factory.scoreboard_script_event(scripts, "player_out_score", { "player_index": 0 }))
	player_out.map(factory.remove_player_event())
	
	play_loop.map(factory.play_cards(0, "Hand", play_pile, UnaRuleset.new(), draw_cards, player_out))

	var break_queue := factory.break_queue(play_loop)
	play_loop.map(factory.players_left_condition(break_queue, 1))

	play_loop.map(factory.next_turn())
