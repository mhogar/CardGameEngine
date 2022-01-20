extends Player
class_name HumanPlayer

var selected_deck : Deck
var selected_card_index : int = -1


func _process(delta):
	if Input.is_action_just_pressed("confirm_card") && selected_card_index >= 0:
		var index := selected_card_index
		reset()
		
		emit_signal("select_card", index)


func reset():
	set_show_outline(selected_deck, false)
	selected_deck.disconnect("selected_card_changed", self, "_on_selected_card_changed")
	selected_card_index = -1


func select_card(deck : Deck):
	set_show_outline(deck, true)
	deck.connect("selected_card_changed", self, "_on_selected_card_changed")
	selected_card_index = deck.selected_card_index
	

func set_show_outline(deck : Deck, val : bool):
	if deck is Hand:
		for card in deck.cards:
			card.set_show_outline(val)
	else:
		deck.get_top_card().set_show_outline(val)


func _on_selected_card_changed(deck : Deck, card_index : int):
	selected_deck = deck
	selected_card_index = card_index
