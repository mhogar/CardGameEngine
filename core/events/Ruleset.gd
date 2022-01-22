extends Node
class_name Ruleset


func is_selectable(card : Card) -> bool:
	var top_card : Card = GameState.piles["play"].get_top_card()
	return card.suit == top_card.suit || card.value == top_card.value
