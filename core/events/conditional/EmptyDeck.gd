extends ConditionalEvent
class_name EmptyDeckCondition


func apply_condition(_ctx : GameContext, inputs : Dictionary) -> bool:
	var deck : Deck = inputs["source_deck"]
	return deck.is_empty()
