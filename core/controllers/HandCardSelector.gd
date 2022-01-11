extends CardSelector
class_name HandCardSelector


func get_hand() -> Hand:
	return get_parent().hand
