extends Event
class_name SelectCardEvent

var controller : Controller


func execute(inputs : Array):
	controller.card_selector.connect("select_card", self, "_on_Hand_select_card", [], CONNECT_ONESHOT)
	controller.card_selector.can_select = true


func _on_Hand_select_card(index : int):
	controller.card_selector.can_select = false
	emit_signal("completed", [index])
