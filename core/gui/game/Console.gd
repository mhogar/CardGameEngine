extends NinePatchRect
class_name Console

onready var label := $RichTextLabel


# Console group
func update_logs(logs : String):
	label.bbcode_text = logs
