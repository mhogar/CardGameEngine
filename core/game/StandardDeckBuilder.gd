extends DeckBuilder
class_name StandardDeckBuilder


func build_deck(deck : Deck):
	for suit in Card.NUM_SUITS:
		for val in Card.NUM_VALUES:
			var card : Card = preload("res://core/card/Card.tscn").instance()
			card.suit = suit
			card.value = val
			
			deck.add_card(card)
