extends Node
class_name CardSelector

signal select_card


func get_hand() -> Hand:
	return get_parent().hand
