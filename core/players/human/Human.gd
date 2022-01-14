extends Player
class_name HumanPlayer

var selected_card_index : int = -1


func _process(delta):
	if Input.is_action_just_pressed("confirm_card") && selected_card_index >= 0:
		emit_signal("select_card", selected_card_index)


func select_card_hand(hand : Hand):
	selected_card_index = randi() % hand.num_cards()
	

func select_card_pile(pile : Pile):
	selected_card_index = pile.get_top_card_index()
