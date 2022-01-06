extends Node2D
class_name Deck

export var max_width : float

onready var cards := $Cards.get_children()


func _ready():
	for i in cards.size():
		cards[i].position.x = (max_width / (cards.size() + 1)) * (i + 1) - max_width / 2.0
