extends Node
class_name EventFactory


func top_card_ruleset() -> Node:
	return preload("res://core/rulesets/TopCardRuleset.tscn").instance()


func una_ruleset() -> Node:
	return preload("res://core/rulesets/UnaRuleset.tscn").instance()


func create_event(event : Event, args : Dictionary = {}) -> Event:
	event.static_args = args
	return event


func null_event() -> Event:
	return create_event(preload("res://core/events/Event.tscn").instance())


func select_card_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/SelectCard.tscn").instance(), args)


func select_top_card_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/SelectTopCard.tscn").instance(), args)


func reveal_card_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/RevealCard.tscn").instance(), args)
	

func move_card_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/MoveCard.tscn").instance(), args)
	

func shuffle_deck_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/ShuffleDeck.tscn").instance(), args)
	

func build_deck_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/BuildDeck.tscn").instance(), args)
	

func apply_ruleset_event(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/ApplyRuleset.tscn").instance(), args)
	

func has_selectable_indices_condition(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/conditional/HasSelectableIndices.tscn").instance(), args)


func deck_empty_condition(args : Dictionary = {}) -> Event:
	return create_event(preload("res://core/events/conditional/EmptyDeck.tscn").instance(), args)


func event_queue(name : String, num_iter : int = 1, args : Dictionary = {}) -> EventQueue:
	var queue : EventQueue = load("res://core/events/EventQueue.tscn").instance()
	queue.name = name
	queue.static_args = queue.merge_inputs({ "num_iter": num_iter }, args)
	return queue
	

func break_queue(target_queue : EventQueue) -> Event:
	var event : Event = preload("res://core/events/BreakQueue.tscn").instance()
	event.target_queue = target_queue
	return event


func move_card(dest : Deck, reveal : bool = false) -> EventQueue:
	var queue := event_queue("MoveCard", 1)
	
	if reveal: queue.merge(reveal_card_event())
	queue.map(move_card_event({ "dest_deck": dest }))
	
	return queue


func move_top_card(src : Deck, dest : Deck, reveal : bool = false) -> EventQueue:
	var queue := event_queue("MoveTopCard", 1)
	
	queue.merge(select_top_card_event({ "source_deck": src }))
	queue.map(move_card(dest, reveal))
	
	return queue
	

func shuffle_pile(pile : Pile) -> Event:
	return shuffle_deck_event({ "source_deck": pile })
	

func build_pile(pile : Pile) -> Event:
	return build_deck_event({ "source_deck": pile })


func deal_cards(pile : Pile, num_cards : int) -> EventQueue:
	var queue := event_queue("DealCards", num_cards)
	
	for player in GameState.players:
		queue.merge(move_top_card(pile, player.hand, player.reveal))
		
	return queue


func draw_cards(player : Player, pile : Pile, num_cards : int = 1) -> EventQueue:
	var queue := event_queue("DrawCards", num_cards, { "source_deck": pile })
	
	queue.merge(apply_ruleset_event({ "ruleset": top_card_ruleset() }))
	queue.merge(select_card_event({ "player": player }))
	queue.map(move_card(player.hand, player.reveal))
	
	return queue
	

func play_cards(player : Player, pile : Pile, cant_play_event : Event, num_cards : int = 1) -> EventQueue:
	var queue := event_queue("TryPlayCards", num_cards, { "source_deck": player.hand })
	queue.merge(apply_ruleset_event({ "ruleset": una_ruleset() }))
	
	var play_queue := event_queue("PlayCards")
	play_queue.merge(select_card_event({ "player": player }))
	play_queue.map(move_card(pile, true))
	
	var event := has_selectable_indices_condition()
	event.init(play_queue, cant_play_event)
	queue.map(event)
	
	return queue
	

func check_deck_empty(deck : Deck, is_empty_event : Event) -> Event:
	var event := deck_empty_condition({ "source_deck": deck })
	event.init(is_empty_event, null_event())
	return event
