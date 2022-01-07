extends Event
class_name SelectCardEvent

var hand : Hand


func execute():
	hand.connect("select_card", self, "_on_Hand_select_card")
	hand.can_select = true


func _on_Hand_select_card(index : int):
	hand.can_select = false
	emit_signal("completed", index)
