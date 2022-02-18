extends Ruleset
class_name TopCardRuleset


func calc_selectable_indices(_ctx : GameContext, deck : Deck) -> Array:
	return [deck.get_top_card_index()]
