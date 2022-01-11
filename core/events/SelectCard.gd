extends Event
class_name SelectCardEvent

var card_selector : CardSelector


func execute(inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var controller : Controller = inputs["controller"]
	
	if deck is Hand:
		card_selector = controller.hand_card_selector
	else:
		card_selector = controller.pile_card_selector
	
	card_selector.connect("select_card", self, "_on_select_card", [], CONNECT_ONESHOT)
	card_selector.start_select(deck)


func _on_select_card(index : int):
	card_selector.end_select()
	emit_signal("completed", self, { "card_index": index })
