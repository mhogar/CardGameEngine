extends Node

onready var event_queue := $EventQueue

onready var player := $Controllers/Player
onready var ai := $Controllers/AI

onready var table := $Table
onready var player_hand := $Table/PlayerHand
onready var ai_hand := $Table/AIHand
onready var play_pile := $Table/PlayPile
onready var draw_pile := $Table/DrawPile


func _ready():
	create_deck(draw_pile, 30)
	
	var num_cards := 10
	create_deck(player_hand, num_cards)
	create_deck(ai_hand, num_cards)
	
	for i in 5:
		add_draw_card_event(player)
		add_move_card_event(draw_pile, player_hand)
		
		add_select_card_event(player)
		add_move_card_event(player_hand, play_pile)
		
		add_draw_card_event(ai)
		add_move_card_event(draw_pile, ai_hand)
		
		add_select_card_event(ai)
		add_move_card_event(ai_hand, play_pile)
	
	event_queue.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event_queue.execute([])


func create_deck(deck : Deck, num_cards : int):
	for i in num_cards:
		var card : Card = preload("res://core/card/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS

		deck.add_card(card)


func add_select_card_event(controller : Controller):
	var event : SelectCardEvent = preload("res://core/events/SelectCard.tscn").instance()
	event.card_selector = controller.hand_card_selector
	
	event_queue.add_event(event)


func add_move_card_event(src : Deck, dest : Deck):
	var event : MoveCardEvent = preload("res://core/events/MoveCard.tscn").instance()
	event.table = table
	event.source_deck = src
	event.dest_deck = dest
	
	event_queue.add_event(event)
	

func add_draw_card_event(controller : Controller):
	var event : SelectCardEvent = preload("res://core/events/SelectCard.tscn").instance()
	event.card_selector = controller.pile_card_selector
	event.card_selector.pile = draw_pile
	
	event_queue.add_event(event)


func _on_event_completed():
	print("queue finished")
