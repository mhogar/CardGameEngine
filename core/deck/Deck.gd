extends Node2D
class_name Deck

export var deck_name := "Deck"
export var is_sorted := false
export var is_face_up := false

var cards := []
var selected_card_index : int = -1


func get_selected_card() -> int:
	return selected_card_index


func shuffle():
	cards.shuffle()
	cards_shuffled()
	

func cards_shuffled():
	pass


func get_card(index : int) -> CardData:
	if index >= cards.size():
		return null
		
	return cards[index]
	

func num_cards() -> int:
	return cards.size()
	

func is_empty() -> bool:
	return cards.empty()


func get_top_card_index() -> int:
	return cards.size() - 1


func get_top_card() -> CardData:
	return cards[get_top_card_index()]


func get_card_index(card : CardData) -> int:
	return cards.find(card)


func add_card(card : CardData):
	var index : int
	
	if is_sorted:
		index = _insert_sorted(card)
	else:
		index = _insert_end(card)
	
	card_added(index, card)
	

func card_added(index : int, card : CardData):
	pass


func remove_card(index : int) -> CardData:
	var card : CardData = cards[index]	
	
	cards.erase(card)
	card_removed(index, card)
	
	return card
	

func card_removed(index : int, card : CardData):
	pass
	

func clear():
	for _index in num_cards():
		remove_card(0)


func get_card_global_position(_index : int) -> Vector2:
	return get_global_position()
	

func set_show_card_outline(_index : int, _val : bool):
	pass


func _insert_sorted(card : CardData) -> int:
	var index := cards.size()
	
	for i in cards.size():
		if card.compare(cards[i]):
			index = i
			break
	
	cards.insert(index, card)
	return index
	

func _insert_end(card : CardData) -> int:
	cards.append(card)
	return get_top_card_index()


func _on_Controller_selected_card_changed(card_index : int):
	emit_signal("selected_card_changed", card_index)
