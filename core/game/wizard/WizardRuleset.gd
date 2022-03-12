extends Ruleset
class_name WizardRuleset


func calc_selectable_indices(ctx : GameContext, deck : Deck) -> Array:
	var play_pile : Pile = ctx.piles["Play Pile"]
	var all_indices := range(deck.num_cards())
	
	if play_pile.is_empty():
		return all_indices
	
	var suit_indices := deck.indices_of_suit(play_pile.get_card(0).suit)
	
	if suit_indices.empty():
		return all_indices
	else:
		return suit_indices
