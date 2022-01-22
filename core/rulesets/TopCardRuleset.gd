extends Ruleset
class_name TopCardRuleset


func calc_selectable_indices(deck : Deck) -> Array:
	return [deck.get_top_card_index()]
