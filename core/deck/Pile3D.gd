extends Spatial
class_name Pile3D

var cards := []


func add_to_top(card : Card3D):
	unset_top_card()
	cards.push_back(card)
	set_top_card()
	

func remove_top() -> Card3D:
	unset_top_card()
	var card : Card3D = cards.pop_back()
	set_top_card()
	
	return card
	

func set_top_card():
	if cards.empty(): return
	
	var card : Card3D = cards.back()
	add_child(card)
	card.set_vertical_scale(cards.size())
	

func unset_top_card():
	if cards.empty(): return null
	
	var card : Card3D = cards.back()
	remove_child(card)
	card.scale.y = 1.0
