extends NinePatchRect
class_name Scoreboard

onready var label := $RichTextLabel


# Scoreboard group
func update_scoreboard(text : String):
	label.bbcode_text = text
