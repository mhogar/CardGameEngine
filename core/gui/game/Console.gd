extends NinePatchRect
class_name Console

onready var label := $RichTextLabel

const PLAYER_COLOR := "teal"
const BLACK_SUIT_COLOR := "silver"
const RED_SUIT_COLOR := "red"


func colored_text(color : String, text : String) -> String:
	return "[color=%s]%s[/color]" % [color, text]


# Console group
func clear_logs():
	label.bbcode_text = ""


# Console group
func log_message(message : String):
	label.bbcode_text += "> %s\n" % message


# Console group
func log_card_drawn(player : Player):
	log_message("%s drew a card" % colored_text(PLAYER_COLOR, player.name))

	
# Console group
func log_card_played(player : Player, card : CardData):	
	log_message("%s played %s" % [colored_text(PLAYER_COLOR, player.name), card.to_bb_text()])


# Console group
func log_player_out(player : Player):
	log_message("%s is out!" % colored_text(PLAYER_COLOR, player.name))
