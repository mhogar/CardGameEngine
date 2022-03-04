extends Event
class_name BuildDeckEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var builder : DeckBuilder = inputs["deck_builder"]
	
	builder.build_deck(deck)
	emit_signal("completed", self, {})
