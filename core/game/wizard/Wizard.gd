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
	

func create_ai_controller() -> Node:
	return preload("res://core/game/wizard/WizardAIController.tscn").instance()


func build_event_queue():
	var play_pile : Pile = game_ctx.piles["Play Pile"]
	var deal_pile : Pile = game_ctx.piles["Deal Pile"]

	game_loop.map(factory.build_pile(deal_pile, StandardDeckBuilder.new()))
	game_loop.map(factory.shuffle_pile(deal_pile))
	game_loop.map(factory.deal_cards(game_ctx.players, "Hand", deal_pile, ROUND))
	game_loop.map(create_round_loop(play_pile))


func create_round_loop(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("RoundLoop", ROUND)
	
	queue.map(create_play_loop(play_pile))
	queue.map(choose_winner(play_pile))
	
	return queue


func create_play_loop(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("PlayLoop", num_players)
	
	queue.map(factory.play_cards(0, "Hand", play_pile, WizardRuleset.new()))
	queue.map(factory.next_turn())
	
	return queue


func choose_winner(play_pile : Pile) -> EventQueue:
	var queue := factory.event_queue("ChooseWinner")
	
	queue.merge(factory.script_event(scripts, "select_winner"))
	queue.merge(factory.select_player_event())
	queue.merge(factory.log_script_event(scripts, "log_set_winner"))
	queue.merge(factory.select_player_deck_event(SelectDeckEvent.DECK_TYPE.DEST, "Sets"))
	queue.merge(factory.move_cards_event(false, { "source_deck": play_pile }))
	queue.merge(factory.set_turn_event())
	
	return queue
