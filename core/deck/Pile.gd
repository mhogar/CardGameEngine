extends Deck
class_name Pile

onready var top_card := $TopCard


func get_selected_card() -> int:
	if top_card.is_mouse_hovering():
		return get_top_card_index()
	else:
		return -1
		

func card_added(index : int, card : CardData):
	if index == get_top_card_index():
		top_card.set_data(card)
		top_card.show()
	

func card_removed(index : int, _card : CardData):
	if index > get_top_card_index():
		if is_empty():
			top_card.hide()	
		else:
			top_card.set_data(get_top_card())
			

func set_show_card_outline(index : int, val : bool):
	if index == get_top_card_index():
		top_card.set_show_outline(val)
