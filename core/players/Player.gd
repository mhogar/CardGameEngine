extends Node2D
class_name Player

signal select_card(index)

onready var decks_node := $Decks

export var player_name : String
var decks := {}


func _ready():
	for deck in decks_node.get_children():
		decks[deck.deck_name] = deck


func get_deck(key : String) -> Deck:
	return decks[key]
	

func clear_decks():
	for key in decks:
		decks[key].clear()


func select_card(_deck : Deck, _indices : Array):
	pass
