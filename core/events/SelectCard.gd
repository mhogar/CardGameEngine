extends Event
class_name SelectCardEvent

var hand : Hand


func execute():
	hand.connect("select_card", self, "_on_Hand_select_card")


func _on_Hand_select_card(index : int):
	emit_signal("completed", index)
