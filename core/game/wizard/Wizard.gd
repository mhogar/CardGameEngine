extends Game
class_name WizardGame

const ROUND := 5

var factory : EventFactory
var scripts : WizardScripts


func _ready():
	factory = EventFactory.new()
	scripts = WizardScripts.new()
	
	init_game()
	build_event_queue()
	start()


func init_scoreboard():
	game_ctx.scoreboard.add_score("Round", 1)
	game_ctx.add_player_score("Round Score")
	game_ctx.add_player_score("Total Score")


func create_ai_controller() -> Node:
	return preload("res://core/game/wizard/WizardAIController.tscn").instance()


func build_event_queue():
	var play_pile : Pile = game_ctx.piles["Play Pile"]
	var deal_pile : Pile = game_ctx.piles["Deal Pile"]

	game_queue.map(factory.build_pile(deal_pile, StandardDeckBuilder.new()))
	game_queue.map(build_game_loop(play_pile, deal_pile))
	
	return EventQueueBuilder.new() \
		.play_cards() \
		.draw_cards() \
		.finalize() \


func build_game_loop(play_pile : Pile, deal_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("GameLoop")
	
	queue.map(factory.shuffle_pile(deal_pile))
	queue.map(factory.deal_cards(game_ctx.players, "Hand", deal_pile, ROUND))
	queue.map(build_round_loop(play_pile))
	queue.map(factory.scoreboard_script_event(scripts, "score_round_end"))
	
	return queue


func build_round_loop(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("RoundLoop", ROUND)
	
	queue.map(build_play_loop(play_pile))
	queue.map(choose_winner(play_pile))
	
	return queue


func build_play_loop(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("PlayLoop", num_players)
	
	queue.map(factory.play_cards(0, "Hand", play_pile, WizardRuleset.new()))
	queue.map(factory.next_turn())
	
	return queue


func choose_winner(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("ChooseWinner")
	
	queue.merge(factory.script_event(scripts, "select_winner"))
	queue.merge(factory.select_player_event())
	queue.merge(factory.log_script_event(scripts, "log_set_winner"))
	queue.merge(factory.scoreboard_script_event(scripts, "score_set_winner"))
	queue.merge(factory.select_player_deck_event(SelectDeckEvent.DECK_TYPE.DEST, "Sets"))
	queue.merge(factory.move_cards_event(false, { "source_deck": play_pile }))
	queue.map(factory.set_turn_event())
	
	return queue
