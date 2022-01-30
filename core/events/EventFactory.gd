extends Node
class_name EventFactory


func top_card_ruleset() -> Node:
	return preload("res://core/rulesets/TopCardRuleset.tscn").instance()


func una_ruleset() -> Node:
	return preload("res://core/rulesets/UnaRuleset.tscn").instance()


func init_event(event : Event, args : Dictionary = {}) -> Event:
	event.static_args = args
	return event


func init_conditional_event(event : ConditionalEvent, true_event : Event, false_event : Event, args : Dictionary = {}) -> Event:
	event.init(true_event, false_event)
	return init_event(event, args)


func null_event() -> Event:
	return init_event(preload("res://core/events/Event.tscn").instance())


func select_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/SelectCard.tscn").instance(), args)


func select_top_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/SelectTopCard.tscn").instance(), args)
	

func move_card_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/MoveCard.tscn").instance(), args)
	

func shuffle_deck_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/ShuffleDeck.tscn").instance(), args)
	

func build_deck_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/BuildDeck.tscn").instance(), args)


func select_player_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/player/SelectPlayer.tscn").instance(), args)
	

func select_player_hand_event(deck_type : int, args : Dictionary = {}) -> Event:
	var event := init_event(preload("res://core/events/player/SelectPlayerHand.tscn").instance(), args)
	event.deck_type = deck_type
	return event 


func next_turn_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/player/NextTurn.tscn").instance(), args)


func apply_ruleset_event(args : Dictionary = {}) -> Event:
	return init_event(preload("res://core/events/ApplyRuleset.tscn").instance(), args)
	

func has_selectable_indices_condition(has_indices_event : Event, no_indices_event : Event, args : Dictionary = {}) -> Event:
	return init_conditional_event(preload("res://core/events/conditional/HasSelectableIndices.tscn").instance(), has_indices_event, no_indices_event, args)


func deck_empty_condition(is_empty_event : Event, args : Dictionary = {}) -> Event:
	return init_conditional_event(preload("res://core/events/conditional/EmptyDeck.tscn").instance(), is_empty_event, null_event(), args)


func event_queue(name : String, num_iter : int = 1, args : Dictionary = {}) -> EventQueue:
	var queue : EventQueue = load("res://core/events/EventQueue.tscn").instance()
	queue.name = name
	queue.static_args = queue.merge_inputs({ "num_iter": num_iter }, args)
	return queue
	

func break_queue(target_queue : EventQueue) -> Event:
	var event : Event = preload("res://core/events/BreakQueue.tscn").instance()
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
	

func build_pile(pile : Pile) -> Event:
	return build_deck_event({ "source_deck": pile })


func deal_cards(pile : Pile, num_cards : int) -> EventQueue:
	var queue := event_queue("DealCards", num_cards)
	
	for player in GameState.players:
		queue.merge(move_top_card(pile, player.hand))
		
	return queue
	

func next_turn() -> Event:
	return next_turn_event()


func draw_cards(player_index : int, pile : Pile, num_cards : int = 1) -> EventQueue:
	var queue := event_queue("DrawCards", num_cards, { "source_deck": pile })
	
	queue.merge(apply_ruleset_event({ "ruleset": top_card_ruleset() }))
	queue.merge(select_player_event({ "player_index": player_index }))
	queue.merge(select_card_event())
	queue.merge(select_player_hand_event(SelectDeckEvent.DECK_TYPE.DEST))
	queue.map(move_card_event())
	
	return queue
	

func play_cards(player_index : int, pile : Pile, cant_play_event : Event) -> EventQueue:
	var queue := event_queue("TryPlayCards")
	
	queue.merge(select_player_event({ "player_index": player_index }))
	queue.merge(select_player_hand_event(SelectDeckEvent.DECK_TYPE.SOURCE))
	queue.merge(apply_ruleset_event({ "ruleset": una_ruleset() }))
	
	var play_queue := event_queue("PlayCards")
	play_queue.merge(select_card_event())
	play_queue.map(move_card(pile))
	
	queue.map(has_selectable_indices_condition(play_queue, cant_play_event))
	
	return queue
	

func check_deck_empty(deck : Deck, is_empty_event : Event) -> Event:
	return deck_empty_condition(is_empty_event, { "source_deck": deck })
	

func check_player_hand_empty(player_index : int, is_empty_event : Event) -> EventQueue:
	var queue := event_queue("CheckPlayerHandEmpty")
	
	queue.merge(select_player_event({ "player_index": player_index }))
	queue.merge(select_player_hand_event(SelectDeckEvent.DECK_TYPE.SOURCE))
	queue.map(deck_empty_condition(is_empty_event))
	
	return queue
