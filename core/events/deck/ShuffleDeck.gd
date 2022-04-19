extends Event
class_name ShuffleDeckEvent

var deck_type : int


func execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs[_resolve_deck_type(deck_type)]
	deck.shuffle()
	
	emit_signal("completed", self, {})
