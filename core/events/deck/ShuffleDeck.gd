extends Event
class_name ShuffleDeckEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	deck.shuffle()
	
	emit_signal("completed", self, {})
