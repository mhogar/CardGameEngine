extends Ruleset
class_name UnaRuleset


func selectable_indices(deck : Deck) -> Array:
	var indices := []
	var top_card : Card = GameState.piles["play"].get_top_card()
	
	for index in deck.num_cards():
		var card := deck.get_card(index)
		
		if card.suit == top_card.suit || card.value == top_card.value:
			indices.append(index)
	
	return indices
