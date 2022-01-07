extends Node2D
class_name Deck

onready var cards_node := $Cards


func _ready():
	randomize()


func num_cards() -> int:
	return cards_node.get_child_count()


func get_cards() -> Array:
	return cards_node.get_children()

