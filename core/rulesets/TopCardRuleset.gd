extends Ruleset
class_name TopCardRuleset


func selectable_indices(deck : Deck) -> Array:
	return [deck.get_top_card_index()]
