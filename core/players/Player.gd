extends Node2D
class_name Player

signal select_card(index)

onready var hand : Hand = $Hand

export var player_name : String


func select_card(_deck : Deck, _indices : Array):
	pass
