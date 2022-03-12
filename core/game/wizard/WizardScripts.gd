extends Node
class_name WizardScripts


func select_winner(ctx : GameContext, inputs : Dictionary) -> Dictionary:
	var play_pile : Pile = ctx.piles["Play Pile"]
	
	var active_suit := play_pile.get_card(0).suit
	var max_score := 0
	var winner := 0
	
	for index in play_pile.num_cards():
		var card := play_pile.get_card(index)
		
		if card.suit != active_suit:
			continue
			
		var score := card.value
		if score > max_score:
			max_score = score
			winner = index
	
	return { "player_index": winner }
