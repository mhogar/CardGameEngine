extends Ruleset
class_name UnaRuleset


func calc_selectable_indices(ctx : GameContext, deck : Deck) -> Array:
	var indices := []
	var top_card : Card = ctx.piles["play"].get_top_card()
	
	for index in deck.num_cards():
		var card := deck.get_card(index)
		
		if card.suit == top_card.suit || card.value == top_card.value:
			indices.append(index)
	
	return indices
