extends Node2D
class_name Deck

signal selected_card_changed(deck, card_index)

onready var cards_node := $Cards

var uid : int
var cards := []
var selected_card_index : int = -1


func _ready():
	randomize()
	uid = UidManager.next_uid()


func build(num_cards : int, face_up : bool = false):
	for i in num_cards:
		var card : Card = preload("res://core/card/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS
		card.face_up = face_up

		add_card(card)


func get_card(index : int) -> Card:
	if index >= cards.size():
		return null
		
	return cards[index]
	

func num_cards() -> int:
	return cards.size()


func get_top_card_index() -> int:
	return cards.size() - 1


func get_top_card() -> Card:
	return cards[get_top_card_index()]


func get_card_index(card : Card) -> int:
	return cards.find(card)


func add_card(card : Card):
	card.z_index = cards.size()
	
	cards.append(card)
	cards_node.add_child(card)
	
	on_card_added(card)
	get_tree().call_group("Deck", "_on_deck_card_added", uid, card)


func on_card_added(card : Card):
	pass


func remove_card(index : int) -> Card:
	recalculate_z_indices(index)
	
	var card : Card = cards[index]
	card.z_index = 0
	
	cards.erase(card)
	cards_node.remove_child(card)
	
	on_card_removed(index, card)
	get_tree().call_group("Deck", "_on_deck_card_removed", uid, index, card)
	return card


func on_card_removed(index : int, card : Card):
	pass
	

func recalculate_z_indices(removed_index : int):
	for i in range(removed_index + 1, cards.size()):
		cards[i].z_index = i - 1


func get_card_relative_position(card : Card) -> Vector2:
	return transform.xform(card.get_sprite_relative_position())


func _on_Controller_selected_card_changed(card_index : int):
	emit_signal("selected_card_changed", card_index)
