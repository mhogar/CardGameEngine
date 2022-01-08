extends Event
class_name SelectCardEvent

var card_selector : CardSelector


func execute(inputs : Array):
	card_selector.connect("select_card", self, "_on_select_card", [], CONNECT_ONESHOT)
	card_selector.start_select()


func _on_select_card(index : int):
	card_selector.end_select()
	emit_signal("completed", [index])
