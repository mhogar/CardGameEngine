extends Game
class_name WizardGame

var scripts : WizardScripts


func _ready():
	scripts = WizardScripts.new()
	
	init_game()
	start()


func init_scoreboard():
	game_ctx.scoreboard.add_score("Round", 1)
	game_ctx.add_player_score("Round Score")
	game_ctx.add_player_score("Total Score")


func create_ai_controller() -> Node:
	return preload("res://core/game/wizard/WizardAIController.tscn").instance()


func build_game_queue() -> EventQueue:
	var play_pile : Pile = game_ctx.piles["Play Pile"]
	var deal_pile : Pile = game_ctx.piles["Deal Pile"]

	return EventQueueBuilder.new("Wizard", [], {}) \
		.build_deck(StandardDeckBuilder.new(), { "source_deck": deal_pile }) \
		.run_script(scripts, "calc_num_rounds", {}) \
		.sub_queue(_game_loop(play_pile, deal_pile)) \
		.get_queue()


func _game_loop(play_pile : Pile, deal_pile : Pile) -> EventQueueBuilder:
	return EventQueueBuilder.new("GameLoop", [], {}) \
		.run_log_script(scripts, "log_round_start", {}) \
		.shuffle_deck(Event.DECK_TYPE.SOURCE, { "source_deck": deal_pile }) \
		.run_script(scripts, "set_round_iterations", {}) \
		.deal_cards({ "deck_name": "Hand", "source_deck": deal_pile }) \
		.next_turn() \
		.sub_queue(_round_loop(play_pile)) \
		.run_log_script(scripts, "log_round_over", {}) \
		.run_scoreboard_script(scripts, "score_round_end", {}) \
		.sub_queue(_clean_up_sets(deal_pile))


func _round_loop(play_pile : Pile) -> EventQueueBuilder:
	var play_loop := EventQueueBuilder.new("PlayLoop", [], {}) \
		.play_card(WizardRuleset.new(), null, null, { "player_index": 0, "deck_name": "Hand", "dest_deck": play_pile }) \
		.next_turn()
	
	return EventQueueBuilder.new("RoundLoop", [], {}) \
		.loop_num_players() \
		.sub_queue(play_loop) \
		.sub_queue(_choose_winner(play_pile))


func _choose_winner(play_pile : Pile) -> EventQueueBuilder:
	return EventQueueBuilder.new("ChooseWinner", [], { "num_iter": 1 }) \
		.run_script(scripts, "select_winner", {}) \
		.select_player({}) \
		.run_log_script(scripts, "log_set_winner", {}) \
		.run_scoreboard_script(scripts, "score_set_winner", {}) \
		.select_player_deck(Event.DECK_TYPE.DEST, { "deck_name": "Sets" }) \
		.move_cards(false, { "source_deck": play_pile }) \
		.set_turn({})


func _clean_up_sets(deal_pile : Pile) -> EventQueueBuilder:
	var clean_up_set_builder := EventQueueBuilder.new("CleanUpSet", [], {}) \
		.select_player({ "player_index": 0 }) \
		.select_player_deck(Event.DECK_TYPE.SOURCE, { "deck_name": "Sets" }) \
		.move_cards(false, { "dest_deck": deal_pile }) \
		.next_turn()
		
	return EventQueueBuilder.new("CleanUpSets", [], { "num_iter": 1 }) \
		.loop_num_players() \
		.sub_queue(clean_up_set_builder)
