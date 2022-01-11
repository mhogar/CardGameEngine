extends HandCardSelector
class_name AIHandCardSelector


func get_rng() -> RandomNumberGenerator:
	return get_parent().rng


func start_select(deck : Deck):
	.start_select(deck)
	emit_signal("select_card", get_rng().randi() % hand.num_cards())
