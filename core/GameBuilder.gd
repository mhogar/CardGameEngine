extends Node
class_name EventQueueBuilder

signal queue_finished

onready var event_queue := $EventQueue


#func create_deck(deck : Deck):
#	for value in Card.NUM_VALUES:
#		for suit in Card.NUM_SUITS:
#			var card : Card = preload("res://core/card/Card.tscn").instance()
#			card.value = value
#			card.suit = suit
#			
#			deck.add_card(card)


func create_deck(deck : Deck, num_cards : int, face_up : bool = false):
	for i in num_cards:
		var card : Card = preload("res://core/card/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS
		card.face_up = face_up

		deck.add_card(card)


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
	

func start_queue(inputs : Dictionary = {}):
	event_queue.execute(inputs)


func _on_EventQueue_completed(event, outputs):
	emit_signal("queue_finished")
