extends Event
class_name SelectCardEvent


func execute(inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var player : Player = inputs["player"]
	var ruleset : Ruleset = inputs["ruleset"]
	
	player.connect("select_card", self, "_on_select_card", [], CONNECT_ONESHOT)
	player.select_card(deck, ruleset.selectable_indices(deck))
	

func _on_select_card(index : int):
	emit_signal("completed", self, { "card_index": index })
