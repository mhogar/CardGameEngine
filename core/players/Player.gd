extends Node2D
class_name Player

signal select_card(index)

onready var hand : Hand = $Hand

var reveal := false


func select_card(deck : Deck, indices : Array):
	pass
