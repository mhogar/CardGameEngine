extends Controller
class_name PlayerController


# Deck Group
func _on_deck_card_added(uid : int, card : Card):
	if uid != hand.uid:
		return
	
	card.set_face_up(true)
