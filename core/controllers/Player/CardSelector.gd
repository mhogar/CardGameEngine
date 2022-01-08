extends CardSelector
class_name PlayerCardSelector

var can_select := false
var hovered_card_indices := []
var selected_card_index : int = -1


func _process(delta):
	if can_select && Input.is_action_just_pressed("confirm_card") && selected_card_index >= 0:
		emit_signal("select_card", selected_card_index)


func start_select():
	can_select = true
	for card in get_hand().get_cards():
		card.set_show_outline(true)


func end_select():
	can_select = false
	for card in get_hand().get_cards():
		card.set_show_outline(false)


func select_card(index : int):
	var old_index := selected_card_index
	selected_card_index = index
	
	if index >= 0:
		get_hand().get_card(index).play_hover_anim()
	
	if old_index >= 0 && old_index < get_hand().num_cards():
		get_hand().get_card(old_index).play_hover_anim(true)


func unselect_card(index : int):
	hovered_card_indices.erase(index)
	if index != selected_card_index:
		return
		
	if hovered_card_indices.empty():
		select_card(-1)
	else:
		select_card(hovered_card_indices.max())

		
func _on_card_mouse_entered(card : Card):
	var index := get_hand().get_card_index(card)
	hovered_card_indices.append(index)
	
	if index > selected_card_index:
		select_card(index)
	

func _on_card_mouse_exited(card : Card):
	unselect_card(get_hand().get_card_index(card))
	
	
# Deck Group
func _on_deck_card_added(uid : int, card : Card):
	if uid != get_hand().uid:
		return
	
	card.connect("card_mouse_entered", self, "_on_card_mouse_entered", [card])
	card.connect("card_mouse_exited", self, "_on_card_mouse_exited", [card])

# Deck Group
func _on_deck_card_removed(uid : int, index : int, card : Card):
	if uid != get_hand().uid:
		return
	
	card.disconnect("card_mouse_entered", self, "_on_card_mouse_entered")
	card.disconnect("card_mouse_exited", self, "_on_card_mouse_exited")
	
	unselect_card(index)
