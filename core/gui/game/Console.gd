extends NinePatchRect
class_name Console

onready var label := $RichTextLabel

const PLAYER_COLOR := "teal"
const BLACK_SUIT_COLOR := "silver"
const RED_SUIT_COLOR := "red"


func colored_text(color : String, text : String) -> String:
	return "[color=%s]%s[/color]" % [color, text]


# Console group
func log_message(message : String):
	label.bbcode_text += "> %s\n" % message


# Console group
func log_card_drawn(player : Player):
	log_message("%s drew a card" % colored_text(PLAYER_COLOR, player.player_name))

	
# Console group
func log_card_played(player : Player, card : Card):
	var value := ""
	match card.value:
		0: value = "Ace"
		1: value = "Two"
		2: value = "Three"
		3: value = "Four"
		4: value = "Five"
		5: value = "Six"
		6: value = "Seven"
		7: value = "Eight"
		8: value = "Nine"
		9: value = "Ten"
		10: value = "Jack"
		11: value = "Queen"
		12: value = "King"
	
	var color := ""
	var suit := ""
	match card.suit:
		0: 
			color = BLACK_SUIT_COLOR
			suit = "Clubs"
		1: 
			color = RED_SUIT_COLOR
			suit = "Diamonds"
		2: 
			color = RED_SUIT_COLOR
			suit = "Hearts"
		3: 
			color = BLACK_SUIT_COLOR
			suit = "Spades"
		
	log_message("%s played %s" % [colored_text(PLAYER_COLOR, player.player_name), colored_text(color, "%s of %s" % [value, suit])])
