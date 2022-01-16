extends Player
class_name HumanPlayer

var selected_deck : Deck
var selected_card_index : int = -1


func _process(delta):
	if Input.is_action_just_pressed("confirm_card") && selected_card_index >= 0:
		var index := selected_card_index
		reset()
		
		emit_signal("select_card", selected_card_index)


func reset():
	if selected_deck is Pile:
		selected_deck.disconnect("selected_card_changed", self, "_on_selected_card_changed")
		selected_deck.get_top_card().set_show_outline(false)
		selected_deck = null
		
	selected_card_index = -1


func select_card(deck : Deck):
	if deck is Hand:
		selected_card_index = randi() % deck.num_cards()
	else:
		deck.get_top_card().set_show_outline(true)
		deck.connect("selected_card_changed", self, "_on_selected_card_changed")


func _on_selected_card_changed(deck : Deck, card_index : int):
	selected_deck = deck
	selected_card_index = card_index
