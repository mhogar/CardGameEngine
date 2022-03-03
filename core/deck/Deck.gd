extends Node2D
class_name Deck

onready var cards_node := $Cards

export var is_sorted := false
export var is_face_up := false
export var deck_name := "Deck"

var cards := []
var selected_card_index : int = -1


func get_selected_card() -> int:
	return selected_card_index


func build():
	for suit in Card.NUM_SUITS:
		for val in Card.NUM_VALUES:
			var card : Card = preload("res://core/card/Card.tscn").instance()
			card.suit = suit
			card.value = val
			add_card(card)
			

func shuffle():
	cards.shuffle()
	recalculate_z_indices()
	

func recalculate_z_indices():
	for i in cards.size():
		cards[i].z_index = i


func get_card(index : int) -> Card:
	if index >= cards.size():
		return null
		
	return cards[index]
	

func num_cards() -> int:
	return cards.size()
	

func is_empty() -> bool:
	return cards.empty()


func get_top_card_index() -> int:
	return cards.size() - 1


func get_top_card() -> Card:
	return cards[get_top_card_index()]


func get_card_index(card : Card) -> int:
	return cards.find(card)


func _insert_sorted(card : Card):
	var index := cards.size() - 1
	
	for i in cards.size():
		if card.compare(cards[i]):
			index = i
			break
	
	cards.insert(index, card)
	recalculate_z_indices()
	

func _insert_end(card : Card):
	card.z_index = cards.size()
	cards.append(card)


func add_card(card : Card):
	if is_sorted && !cards.empty():
		_insert_sorted(card)
	else:
		_insert_end(card)
	
	cards_node.add_child(card)
	on_card_added(card)


func on_card_added(_card : Card):
	pass


func remove_card(index : int) -> Card:
	var card : Card = cards[index]
	card.z_index = 0
	
	cards.erase(card)
	cards_node.remove_child(card)
	recalculate_z_indices()
	
	on_card_removed(index, card)
	return card


func on_card_removed(_index : int, _card : Card):
	pass
	

func clear():
	for card in cards:
		card.queue_free()
	
	cards.clear()


func get_card_relative_position(card : Card) -> Vector2:
	return transform.xform(card.get_sprite_relative_position())


func _on_Controller_selected_card_changed(card_index : int):
	emit_signal("selected_card_changed", card_index)
