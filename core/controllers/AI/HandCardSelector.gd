extends HandCardSelector
class_name AIHandCardSelector


func get_rng() -> RandomNumberGenerator:
	return get_parent().rng


func start_select():
	emit_signal("select_card", get_rng().randi() % get_hand().num_cards())
