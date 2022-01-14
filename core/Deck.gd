extends Node2D
class_name Deck

onready var cards_node := $Cards

var uid : int


func _ready():
	randomize()
	uid = UidManager.next_uid()


func num_cards() -> int:
	return cards_node.get_child_count()


func get_cards() -> Array:
	var foo := cards_node.get_children()
	return foo


func get_card(index : int) -> Card:
	return get_cards()[index]


func get_top_card_index() -> int:
	return num_cards() - 1


func get_top_card() -> Card:
	return get_card(get_top_card_index())


func get_card_index(card : Card) -> int:
	return get_cards().find(card)


func add_card(card : Card):
	card.z_index = num_cards()
	cards_node.add_child(card)
	get_tree().call_group("Deck", "_on_deck_card_added", uid, card)


func remove_card(index : int) -> Card:
	var card := get_card(index)
	card.z_index = 0
	cards_node.remove_child(card)
	
	get_tree().call_group("Deck", "_on_deck_card_removed", uid, index, card)
	
	return card


func get_card_relative_position(card : Card) -> Vector2:
	return transform.xform(card.get_sprite_relative_position())
