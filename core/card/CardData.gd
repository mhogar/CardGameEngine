extends Resource
class_name CardData

export(int, 12) var value : int
export(int, 3) var suit : int
export var face_up := false

const NUM_VALUES := 13
const NUM_SUITS := 4

const BLACK_SUIT_COLOR := "silver"
const RED_SUIT_COLOR := "red"


func _init(v : int = 0, s: int = 0):
	value = v
	suit = s


func compare(other : CardData) -> bool:
	if suit != other.suit:
		return suit < other.suit
	
	return value < other.value


func to_text() -> String:
	return "%s %s" % [_value_to_string(), suit_to_text()]
	

func to_bb_text() -> String:
	return "[color=%s]The %s of %s[/color]" % [_get_suit_color(), _value_to_string(), suit_to_text()]


func suit_to_text() -> String:
	match suit:
		0: return "Clubs"
		1: return "Diamonds"
		2: return "Hearts"
		3: return "Spades"

	return ""


func suit_to_bb_text() -> String:
	return "[color=%s]%s[/color]" % [_get_suit_color(), suit_to_text()]


func _value_to_string() -> String:
	match value:
		0: return "Ace"
		1: return "Two"
		2: return "Three"
		3: return "Four"
		4: return "Five"
		5: return "Six"
		6: return "Seven"
		7: return "Eight"
		8: return "Nine"
		9: return "Ten"
		10: return "Jack"
		11: return "Queen"
		12: return "King"
		
	return ""
	

func _get_suit_color() -> String:
	match suit:
		0: return BLACK_SUIT_COLOR
		1: return RED_SUIT_COLOR
		2: return RED_SUIT_COLOR
		3: return BLACK_SUIT_COLOR
		
	return "white"
