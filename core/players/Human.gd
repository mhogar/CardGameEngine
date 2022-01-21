extends Player
class_name HumanPlayer

var target_deck : Deck


func _process(delta):
	if target_deck != null && Input.is_action_just_pressed("confirm_card"):
		var index := target_deck.get_selected_card()
		if index >= 0:
			set_show_outline(target_deck, false)
			target_deck = null
			emit_signal("select_card", index)
			

func select_card(deck : Deck):
	target_deck = deck
	set_show_outline(target_deck, true)
	

func set_show_outline(deck : Deck, val : bool):
	if deck is Hand:
		for card in deck.cards:
			card.set_show_outline(val)
	else:
		deck.get_top_card().set_show_outline(val)
