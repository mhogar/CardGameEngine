extends Deck
class_name Hand

onready var tween := $Tween

const MAX_WIDTH := 500.0


func adjust_spacing():
	tween.remove_all()
	
	var spacing := MAX_WIDTH / (num_cards() + 1)
	for i in num_cards():
		var card := get_card(i)
		
		var start_pos := card.position.x
		var new_pos : float = spacing * (i + 1) - (MAX_WIDTH / 2.0)
		
		tween.interpolate_property(card, "position:x", start_pos, new_pos, abs(start_pos - new_pos) / 300.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.start()


func add_card(card : Card):
	.add_card(card)
	adjust_spacing()


func remove_card(index : int) -> Card:
	var card := .remove_card(index)
	adjust_spacing()
	return card
