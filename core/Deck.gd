extends Node2D
class_name Deck

onready var cards_node := $Cards


func _ready():
	randomize()


func num_cards() -> int:
	return cards_node.get_child_count()


func get_cards() -> Array:
	return cards_node.get_children()


func get_card(index : int) -> Card:
	return get_cards()[index]


func add_card(card : Card):
	cards_node.add_child(card)


func remove_card(index : int) -> Card:
	var card := get_card(index)
	cards_node.remove_child(card)
	return card
	

func get_card_relative_position(card : Card) -> Vector2:
	return transform.xform(card.get_sprite_relative_position())
