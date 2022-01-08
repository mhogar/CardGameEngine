extends Node

onready var player := $Controllers/Player

onready var table := $Table
onready var hand := $Table/Hand
onready var play_pile := $Table/PlayPile
onready var event_queue := $EventQueue


func _ready():
	create_hand(10)
	
	for i in 5:
		add_select_card_event()
		add_move_card_event()
	
	event_queue.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event_queue.execute([])


func create_hand(num_cards : int):
	for i in num_cards:
		var card : Card = preload("res://core/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS

		hand.add_card(card)
	
	hand.adjust_spacing()


func add_select_card_event():
	var event : SelectCardEvent = preload("res://core/events/SelectCard.tscn").instance()
	event.controller = player
	
	event_queue.add_event(event)


func add_move_card_event():
	var event : MoveCardEvent = preload("res://core/events/MoveCard.tscn").instance()
	event.table = table
	event.source_hand = hand
	event.dest_deck = play_pile
	
	event_queue.add_event(event)


func _on_event_completed():
	print("queue finished")
