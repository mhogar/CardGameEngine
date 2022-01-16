extends Deck
class_name Pile

var top_card : Card = null


func on_card_added(card : Card):
	if top_card != null:
		disconnect_signals(top_card)
	
	top_card = card
	connect_signals(top_card)


func on_card_removed(index : int, card : Card):
	disconnect_signals(top_card)
	
	top_card = get_top_card()
	
	if top_card != null:
		connect_signals(top_card)
		selected_card_index = get_top_card_index()
	else:
		selected_card_index = -1


func connect_signals(card : Card):
	top_card.connect("card_mouse_entered", self, "_on_card_mouse_entered")
	top_card.connect("card_mouse_exited", self, "_on_card_mouse_exited")


func disconnect_signals(card : Card):
	top_card.disconnect("card_mouse_entered", self, "_on_card_mouse_entered")
	top_card.disconnect("card_mouse_exited", self, "_on_card_mouse_exited")


func _on_card_mouse_entered():
	selected_card_index = get_top_card_index()
	emit_signal("selected_card_changed", self, selected_card_index)


func _on_card_mouse_exited():
	selected_card_index = -1
	emit_signal("selected_card_changed", self, selected_card_index)
