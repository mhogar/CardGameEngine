extends AIController
class_name UnaAIController
	

func select_index(_ctx : GameContext, deck : Deck, indices : Array) -> int:
	var selected_index := 0
	var max_playable := 0
	
	for index in indices:
		var playable := 0
		var playable_card := deck.get_card(index)
		
		for card in deck.cards:
			if card.value == playable_card.value || card.suit == playable_card.suit:
				playable += 1
		
		if playable > max_playable:
			max_playable = playable
			selected_index = index
			
	return selected_index
