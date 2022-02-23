extends Spatial
class_name Pile3D

onready var card : Card3D = $Card

var cards := []


func _ready():
	card.hide()


func add_to_top(data : CardData):
	cards.push_back(data)
	update_card(data)
	card.show()
	

func remove_top() -> CardData:
	var data : CardData = cards.pop_back()
	
	if cards.empty():
		card.hide()
	else:
		update_card(cards.back())
	
	return data
	

func update_card(data : CardData):
	card.set_data(data)
	card.set_vertical_scale(cards.size())
