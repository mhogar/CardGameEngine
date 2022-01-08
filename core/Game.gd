extends Node

onready var event_queue := $EventQueue

onready var player := $Controllers/Player
onready var ai := $Controllers/AI

onready var table := $Table
onready var player_hand := $Table/PlayerHand
onready var ai_hand := $Table/AIHand
onready var play_pile := $Table/PlayPile


func _ready():
	var num_cards := 10
	create_hand(player_hand, num_cards)
	create_hand(ai_hand, num_cards)
	
	for i in num_cards:
		add_select_card_event(player)
		add_move_card_event(player_hand)
		
		add_select_card_event(ai)
		add_move_card_event(ai_hand)
	
	event_queue.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event_queue.execute([])


func create_hand(hand : Hand, num_cards : int):
	for i in num_cards:
		var card : Card = preload("res://core/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS

		hand.add_card(card)


func add_select_card_event(controller : Controller):
	var event : SelectCardEvent = preload("res://core/events/SelectCard.tscn").instance()
	event.card_selector = controller.card_selector
	
	event_queue.add_event(event)


func add_move_card_event(source_hand : Hand):
	var event : MoveCardEvent = preload("res://core/events/MoveCard.tscn").instance()
	event.table = table
	event.source_hand = source_hand
	event.dest_deck = play_pile
	
	event_queue.add_event(event)


func _on_event_completed():
	print("queue finished")
