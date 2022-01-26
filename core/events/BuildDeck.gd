extends Event
class_name BuildDeckEvent


func execute(inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	deck.build()
	
	emit_signal("completed", self, {})
