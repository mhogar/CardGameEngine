extends Deck
class_name Pile

var top_card : Card = null


func get_selected_card() -> int:
	if get_top_card().is_mouse_hovering():
		return get_top_card_index()
	else:
		return -1
