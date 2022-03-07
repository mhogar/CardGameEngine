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
	return "%s %s" % [_value_to_string(), _suit_to_string()]
	

func to_bb_text() -> String:
	return "%s [color=%s]%s[/color]" % [_value_to_string(), _get_suit_color(), _suit_to_string()]


func _value_to_string() -> String:
	match value:
		0: return "The Ace"
		1: return "The Two"
		2: return "The Three"
		3: return "The Four"
		4: return "The Five"
		5: return "The Six"
		6: return "The Seven"
		7: return "The Eight"
		8: return "The Nine"
		9: return "The Ten"
		10: return "The Jack"
		11: return "The Queen"
		12: return "The King"
		
	return ""
	

func _get_suit_color() -> String:
	match suit:
		0: return BLACK_SUIT_COLOR
		1: return RED_SUIT_COLOR
		2: return RED_SUIT_COLOR
		3: return BLACK_SUIT_COLOR
		
	return "white"
			
			
func _suit_to_string() -> String:
	match suit:
		0: return "of Clubs"
		1: return "of Diamonds"
		2: return "of Hearts"
		3: return "of Spades"

	return ""
	
