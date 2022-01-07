extends Node

onready var table := $Table
onready var hand := $Table/Hand
onready var play_pile := $Table/PlayPile
onready var event_queue := $EventQueue

func _ready():
	for i in 5:
		add_move_card_event()
	
	event_queue.connect("completed", self, "_on_event_completed")
	event_queue.execute()


func add_move_card_event():
	var event : MoveCardEvent = preload("res://core/events/MoveCard.tscn").instance()
	event.table = table
	event.source_hand = hand
	event.dest_deck = play_pile
	
	event_queue.add_event(event)


func _on_event_completed():
	print("queue finished")
