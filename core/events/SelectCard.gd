extends Event
class_name SelectCardEvent


func execute(inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var player : Player = inputs["player"]
	
	player.connect("select_card", self, "_on_select_card", [], CONNECT_ONESHOT)
	player.select_card(deck)
	

func _on_select_card(index : int):
	emit_signal("completed", self, { "card_index": index })
