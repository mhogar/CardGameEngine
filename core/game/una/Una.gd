extends Game
class_name UnaGame

var scripts : UnaScripts

func _ready():
	scripts = UnaScripts.new()
	
	init_game()
	build_event_queue()
	start()


func init_scoreboard():
	game_ctx.add_player_score("Score")
	

func create_ai_controller() -> Node:
	return preload("res://core/game/una/UnaAIController.tscn").instance()


func build_event_queue():	
	var play_pile : Pile = game_ctx.piles["Play Pile"]
	var draw_pile : Pile = game_ctx.piles["Draw Pile"]

	game_queue = EventQueueBuilder.new("Una", [], {}) \
		.sub_queue(_setup_piles(draw_pile, play_pile)) \
		.sub_queue(_play_loop(draw_pile, play_pile)) \
		.get_queue()
		
	add_child(game_queue)
	

func _setup_piles(draw_pile : Pile, play_pile : Pile) -> EventQueueBuilder:
	return EventQueueBuilder.new("SetupDrawPile", [], { "source_deck": draw_pile }) \
		.build_deck(StandardDeckBuilder.new(), {}) \
		.shuffle_deck(Event.DECK_TYPE.SOURCE, {}) \
		.deal_cards({ "num_iter": 5, "deck_name": "Hand" }) \
		.move_top_card({ "dest_deck": play_pile })
		

func _play_loop(draw_pile : Pile, play_pile : Pile) -> EventQueueBuilder:
	var reshuffle_draw_pile := EventQueueBuilder.new("ReshuffleDrawPile", [], {}) \
		.reshuffle_deck(true, { "source_deck": play_pile, "dest_deck": draw_pile })
	
	var draw_cards := EventQueueBuilder.new("DrawCards", [], {}) \
		.draw_cards(reshuffle_draw_pile.get_queue(), { "num_iter": 1, "player_index": 0, "deck_name": "Hand", "source_deck": draw_pile })
	
	var player_out := EventQueueBuilder.new("PlayerOut", [], { "player_index": 0 }) \
		.run_scoreboard_script(scripts, "player_out_score", {}) \
		.player_out({})
	
	var break_play_loop := EventQueueBuilder.new("BreakPlayLoop", [], {}) \
		.break_queue(2)
	
	return EventQueueBuilder.new("PlayLoop", [], { "num_iter": 0 }) \
		.play_card(UnaRuleset.new(), draw_cards.get_queue(), player_out.get_queue(), { "player_index": 0, "deck_name": "Hand", "dest_deck": play_pile }) \
		.players_left_condition(break_play_loop.get_queue(), { "num_players": 1 }) \
		.next_turn()
