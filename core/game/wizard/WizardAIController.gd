extends AIController
class_name WizardAIController


func select_index(ctx : GameContext, deck : Deck, indices : Array) -> int:
	var play_pile : Pile = ctx.piles["Play Pile"]
	var stats := DeckStats.new(deck, indices)
	
	if play_pile.is_empty():
		return stats.max_value_index()
		
	var active_suit := play_pile.get_card(0).suit
	
	if stats.has_suit(active_suit):
		return stats.max_value_index(active_suit)
	else:
		return stats.min_value_index()
