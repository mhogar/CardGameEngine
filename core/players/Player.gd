extends Node2D
class_name Player

export var table_index := 0

onready var decks_node := $Decks

var decks := {}


func _ready():
	for deck in decks_node.get_children():
		decks[deck.name] = deck


func get_deck(key : String) -> Deck:
	return decks[key]
	

func clear_decks():
	for key in decks:
		decks[key].clear()


func get_controller() -> PlayerController:
	var controller : PlayerController = $Controller
	return controller
