extends Event
class_name SelectTopCardEvent


func _execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	emit_signal("completed", self, { "card_index": deck.get_top_card_index() })
