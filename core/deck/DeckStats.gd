extends Resource
class_name DeckStats

var data := {}


func _init(deck : Deck, indices : Array):
	for index in indices:
		_add_card(index, deck.get_card(index))


func has_suit(suit : int) -> bool:
	return suit in data


func min_value_index(suit : int = -1) -> int:
	if suit >= 0:
		return data[suit]["min_index"]
	
	var min_value := -1
	var min_index := 0
	
	for key in data:
		var value : int = data[key]["min_value"]
		if min_value < 0 || value < min_value:
			min_value = value
			min_index = data[key]["min_index"]
	
	return min_index
	

func max_value_index(suit : int = -1) -> int:
	if suit >= 0:
		return data[suit]["max_index"]
	
	var max_value := -1
	var max_index := 0
	
	for key in data:
		var value : int = data[key]["max_value"]
		if max_value < 0 || value > max_value:
			max_value = value
			max_index = data[key]["max_index"]
	
	return max_index


func _add_card(index : int, card : CardData):
	var suit := card.suit
	
	if not has_suit(suit):
		data[card.suit] = {
			"min_index": index,
			"min_value": card.value,
			"max_index": index,
			"max_value": card.value,
		}
		return
	
	var min_value = data[suit]["min_value"]
	
	if min_value < 0 || card.value < min_value:
		data[suit]["min_index"] = index
		data[suit]["min_value"] = card.value
		return
		
	var max_value = data[suit]["max_value"]
	
	if max_value < 0 || card.value > max_value:
		data[suit]["max_index"] = index
		data[suit]["max_value"] = card.value
