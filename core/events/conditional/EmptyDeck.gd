extends ConditionalEvent
class_name EmptyDeckCondition


func apply_condition(inputs : Dictionary) -> bool:
	var deck : Deck = inputs["source_deck"]
	return deck.is_empty()
