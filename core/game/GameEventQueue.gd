extends EventQueue
class_name GameEventQueue


func select_card() -> Node:
	return preload("res://core/events/SelectCard.tscn").instance()


func select_top_card() -> Node:
	return preload("res://core/events/SelectTopCard.tscn").instance()


func reveal_card() -> Node:
	return preload("res://core/events/RevealCard.tscn").instance()
	

func move_card() -> Node:
	return preload("res://core/events/MoveCard.tscn").instance()


func sub_queue(name : String, type : int, num_iter : int = 1, inputs : Dictionary = {}) -> GameEventQueue:
	var queue : GameEventQueue = load("res://core/game/GameEventQueue.tscn").instance()
	queue.name = name
	
	add_event(queue, type, merge_inputs({ "num_iter": num_iter }, inputs))
	return queue


func shuffle_deck():
	pass
	

func take_from_pile(player : Player, pile : Pile, event_type : int = EventType.MAP):
	var queue := sub_queue("TakeFromPile", event_type, 1, { "source_deck": pile })
	
	if player is HumanPlayer: queue.merge(reveal_card())
	queue.map(move_card(), { "dest_deck": player.hand })


func deal_cards(players : Array, pile : Pile, num_cards : int, event_type : int = EventType.MAP):
	var queue := sub_queue("DealCards", event_type, num_cards, { "source_deck": pile })
	
	for player in players:
		queue.merge(select_top_card())
		queue.take_from_pile(player, pile, EventType.MERGE)


func draw_cards(player : Player, pile : Pile, num_cards : int = 1, event_type : int = EventType.MAP):
	var queue := sub_queue("DrawCards", event_type, num_cards, { "player": player })
	
	queue.merge(select_card(), { "source_deck": pile })
	queue.take_from_pile(player, pile)


func play_cards(player : Player, pile : Pile, num_cards : int = 1, event_type : int = EventType.MAP):
	var queue := sub_queue("PlayCards", event_type, num_cards, { "player": player })
	
	queue.merge(select_card(), { "source_deck": player.hand })
	queue.merge(reveal_card())
	queue.map(move_card(), { "dest_deck": pile })
