extends Node
class_name EventFactory


func init_event(event : Event, args : Dictionary = {}) -> Event:
	event.static_args = args
	return event


func init_conditional_event(event : ConditionalEvent, true_event : Event, false_event : Event, args : Dictionary = {}) -> Event:
	event.init(true_event, false_event)
	return init_event(event, args)


func init_script_event(event : ScriptEvent, object : Node, func_name : String, args : Dictionary = {}) -> Event:
	event.object = object
	event.func_name = func_name
	return init_event(event, args)


func null_event() -> Event:
	return init_event(preload("res://core/events/Event.tscn").instance())


func select_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/SelectCard.tscn").instance(), args)


func select_top_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/SelectTopCard.tscn").instance(), args)
	

func move_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/MoveCard.tscn").instance(), args)
	
func move_cards_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/MoveCards.tscn").instance(), args)
	

func log_card_played_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/LogCardPlayed.tscn").instance(), args)
	
	
func log_card_drawn_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/card/LogCardDrawn.tscn").instance(), args)
	

func shuffle_deck_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/deck/ShuffleDeck.tscn").instance(), args)
	

func build_deck_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/deck/BuildDeck.tscn").instance(), args)


func select_player_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/player/SelectPlayer.tscn").instance(), args)
	

func select_player_hand_event(deck_type : int, args : Dictionary = {}) -> Event:
	var event := init_event(preload("res://core/events/player/SelectPlayerHand.tscn").instance(), args)
	event.deck_type = deck_type
	return event 


func remove_player_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/player/RemovePlayer.tscn").instance(), args)
	

func next_turn_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/player/NextTurn.tscn").instance(), args)


func apply_ruleset_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/ruleset/ApplyRuleset.tscn").instance(), args)
	

func has_selectable_indices_condition(has_indices_event : Event, no_indices_event : Event, args : Dictionary = {}) -> Event:
	return init_conditional_event(preload("res://core/events/conditional/HasSelectableIndices.tscn").instance(), has_indices_event, no_indices_event, args)


func deck_empty_condition(is_empty_event : Event, args : Dictionary = {}) -> Event:
	return init_conditional_event(preload("res://core/events/conditional/EmptyDeck.tscn").instance(), is_empty_event, null_event(), args)
	

func players_left_condition(players_left_event : Event, num_players : int) -> Event:
	return init_conditional_event(preload("res://core/events/conditional/PlayersLeft.tscn").instance(), players_left_event, null_event(), { "num_players": num_players })


func script_event(object : Node, func_name : String, args : Dictionary = {}) -> Event:
	return init_script_event(preload("res://core/events/script/ScriptEvent.tscn").instance(), object, func_name, args)


func scoreboard_script_event(object : Node, func_name : String, args : Dictionary = {}) -> Event:
	return init_script_event(preload("res://core/events/script/ScoreboardScript.tscn").instance(), object, func_name, args)


func event_queue(name : String, num_iter : int = 1, args : Dictionary = {}) -> EventQueue:
	var queue : EventQueue = load("res://core/events/queue/EventQueue.tscn").instance()
	queue.name = name
	queue.static_args = queue.merge_inputs({ "num_iter": num_iter }, args)
	return queue
	

func break_queue(target_queue : EventQueue) -> Event:
	var event : Event = preload("res://core/events/queue/BreakQueue.tscn").instance()
	event.name = "BreakQueue"
	event.target_queue = target_queue
	return event


func move_card(dest : Deck) -> Event:
	return move_card_event({ "dest_deck": dest })


func move_top_card(src : Deck, dest : Deck) -> EventQueue:
	var queue := event_queue("MoveTopCard", 1)
	
	queue.merge(select_top_card_event({ "source_deck": src }))
	queue.map(move_card(dest))
	
	return queue
	

func shuffle_pile(pile : Pile) -> Event:
	return shuffle_deck_event({ "source_deck": pile })
	

func build_pile(pile : Pile, builder : DeckBuilder) -> Event:
	return build_deck_event({ "source_deck": pile, "deck_builder": builder })


func deal_cards(players : Array, pile : Pile, num_cards : int) -> EventQueue:
	var queue := event_queue("DealCards", num_cards)
	
	for player in players:
		queue.merge(move_top_card(pile, player.hand))
		
	return queue
	

func next_turn() -> Event:
	return next_turn_event()


func draw_cards(player_index : int, pile : Pile, deck_emptied_event : Event, num_cards : int = 1) -> EventQueue:
	var queue := event_queue("DrawCards", num_cards, { "source_deck": pile })
	
	queue.merge(apply_ruleset_event({ "ruleset": TopCardRuleset.new() }))
	queue.merge(select_player_event({ "player_index": player_index }))
	queue.merge(select_card_event())
	queue.merge(select_player_hand_event(SelectDeckEvent.DECK_TYPE.DEST))
	queue.merge(log_card_drawn_event())
	queue.merge(move_card_event())
	queue.map(deck_empty_condition(deck_emptied_event))
	
	return queue
	

func play_cards(player_index : int, pile : Pile, ruleset : Ruleset, cant_play_event : Event, hand_emptied_event : Event) -> EventQueue:
	var queue := event_queue("TryPlayCards")
	
	queue.merge(select_player_event({ "player_index": player_index }))
	queue.merge(select_player_hand_event(SelectDeckEvent.DECK_TYPE.SOURCE))
	queue.merge(apply_ruleset_event({ "ruleset": ruleset }))
	
	var play_queue := event_queue("PlayCards")
	play_queue.merge(select_card_event())
	play_queue.merge(log_card_played_event())
	play_queue.merge(move_card(pile))
	play_queue.map(deck_empty_condition(hand_emptied_event))
	
	queue.map(has_selectable_indices_condition(play_queue, cant_play_event))
	
	return queue
	
	
func reshuffle_pile(pile : Pile, source : Pile) -> EventQueue:
	var queue := event_queue("ReshufflePile")
	
	queue.merge(move_cards_event({ "source_deck": source, "dest_deck": pile }))
	queue.map(shuffle_pile(pile))
	
	return queue


func remove_player(index : int) -> Event:
	return remove_player_event({ "player_index": index })
