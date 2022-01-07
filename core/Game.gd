extends Node

onready var table := $Table
onready var hand := $Table/Hand
onready var play_pile := $Table/PlayPile


func _ready():
	var move_card_event : MoveCardEvent = preload("res://core/events/MoveCard.tscn").instance()
	move_card_event.table = table
	move_card_event.source_hand = hand
	move_card_event.dest_deck = play_pile
	
	move_card_event.connect("completed", self, "_on_move_card_completed")
	move_card_event.execute()
	

func _on_move_card_completed():
	print("card moved")
