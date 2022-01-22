extends EventQueue
class_name GameEventQueue


func select_card_event() -> Node:
	return preload("res://core/events/SelectCard.tscn").instance()


func select_top_card_event() -> Node:
	return preload("res://core/events/SelectTopCard.tscn").instance()


func reveal_card_event() -> Node:
	return preload("res://core/events/RevealCard.tscn").instance()
	

func move_card_event() -> Node:
	return preload("res://core/events/MoveCard.tscn").instance()
	

func shuffle_deck_event() -> Node:
	return preload("res://core/events/ShuffleDeck.tscn").instance()


func sub_queue(name : String, type : int, num_iter : int = 1, inputs : Dictionary = {}) -> GameEventQueue:
	var queue : GameEventQueue = load("res://core/game/GameEventQueue.tscn").instance()
	queue.name = name
	
	add_event(queue, type, merge_inputs({ "num_iter": num_iter }, inputs))
	return queue
	

func move_card(dest : Deck, reveal : bool = false, event_type : int = EventType.MAP):
	var queue := sub_queue("MoveCard", event_type, 1)
	
	if reveal: queue.merge(reveal_card_event())
	queue.map(move_card_event(), { "dest_deck": dest })


func move_top_card(dest : Deck, reveal : bool = false, event_type : int = EventType.MAP):
	var queue := sub_queue("MoveTopCard", event_type, 1)
	
	queue.merge(select_top_card_event())
	queue.move_card(dest, reveal)


func shuffle_pile(pile : Pile, event_type : int = EventType.MAP):
	add_event(shuffle_deck_event(), event_type, { "source_deck": pile })


func deal_cards(players : Array, pile : Pile, num_cards : int, event_type : int = EventType.MAP):
	var queue := sub_queue("DealCards", event_type, num_cards, { "source_deck": pile })
	
	for player in players:
		queue.move_top_card(player.hand, player is HumanPlayer, EventType.MERGE)


func draw_cards(player : Player, pile : Pile, num_cards : int = 1, event_type : int = EventType.MAP):
	var queue := sub_queue("DrawCards", event_type, num_cards, { "player": player })
	
	queue.merge(select_card_event(), { "source_deck": pile })
	queue.move_card(player.hand, player is HumanPlayer)


func play_cards(player : Player, pile : Pile, num_cards : int = 1, event_type : int = EventType.MAP):
	var queue := sub_queue("PlayCards", event_type, num_cards, { "player": player })
	
	queue.merge(select_card_event(), { "source_deck": player.hand })
	queue.move_card(pile, true)
