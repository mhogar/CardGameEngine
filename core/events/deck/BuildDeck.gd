extends Event
class_name BuildDeckEvent

var builder : DeckBuilder


func _execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	
	builder.build_deck(deck)
	emit_signal("completed", self, {})
