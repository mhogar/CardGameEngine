extends Node
class_name Ruleset
	

func calc_selectable_indices(deck : Deck) -> Array:
	return range(deck.num_cards())
