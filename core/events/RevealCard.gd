extends Event
class_name RevealCardEvent


func execute(inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	deck.get_card(inputs["card_index"]).set_face_up(true)
	
	emit_signal("completed", self, {})
