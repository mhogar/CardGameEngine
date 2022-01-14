extends Node
class_name EventQueueBuilder

onready var event_queue : EventQueue = $EventQueue


func shuffle_deck():
	pass


func draw_card(player : Player, pile : Pile):
	merge(select_card(), { "player": player, "source_deck": pile })
	if player is HumanPlayer:
		merge(reveal_card())
	map(move_card(), { "dest_deck": player.hand })


func play_card(player : Player, pile : Pile):
	merge(select_card(), { "player": player, "source_deck": player.hand })
	merge(reveal_card())
	map(move_card(), { "dest_deck": pile })


func select_card() -> Node:
	return preload("res://core/events/SelectCard.tscn").instance()


func reveal_card() -> Node:
	return preload("res://core/events/RevealCard.tscn").instance()
	

func move_card() -> Node:
	return preload("res://core/events/MoveCard.tscn").instance()


func map(event : Event, inputs : Dictionary = {}):
	event_queue.add_event(event, Event.EventType.MAP, inputs)
	
	
func merge(event : Event, inputs : Dictionary = {}):
	event_queue.add_event(event, Event.EventType.MERGE, inputs)
