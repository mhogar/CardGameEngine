extends PlayerController
class_name HumanController

var target_deck : Deck
var selectable_indices : Array


func _physics_process(delta):
	if target_deck != null && Input.is_action_just_pressed("confirm_card"):
		var index := target_deck.get_selected_card()
		if index in selectable_indices:
			set_show_outline(false)
			target_deck = null
			emit_signal("select_card", index)
			

func select_card(deck : Deck, indices : Array):
	target_deck = deck
	selectable_indices = indices
	set_show_outline(true)
	

func set_show_outline(val : bool):
	for index in selectable_indices:
		target_deck.set_show_card_outline(index, val)
