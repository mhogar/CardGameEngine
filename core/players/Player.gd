extends Node2D
class_name Player

signal select_card(index)

onready var hand := $Hand


func select_card(deck : Deck):
	if deck is Hand:
		select_card_hand(deck)
	else:
		select_card_pile(deck)


func select_card_hand(hand : Hand):
	pass
	

func select_card_pile(pile : Pile):
	pass
