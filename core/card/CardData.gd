extends Resource
class_name CardData

const NUM_VALUES := 13
const NUM_SUITS := 4

export(int, 12) var value : int
export(int, 3) var suit : int


func _init(value : int, suit : int):
	self.value = value
	self.suit = suit
