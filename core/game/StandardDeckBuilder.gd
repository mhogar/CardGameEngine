extends DeckBuilder
class_name StandardDeckBuilder


func build_deck(deck : Deck):
	for suit in CardData.NUM_SUITS:
		for val in CardData.NUM_VALUES/4:			
			deck.add_card(CardData.new(val, suit))
