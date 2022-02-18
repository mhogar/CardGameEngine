extends Event
class_name SelectCardEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var player : Player = inputs["player"]
	var selectable_indices : Array = inputs["selectable_indices"]
	
	player.connect("select_card", self, "_on_select_card", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	player.select_card(deck, selectable_indices)
	

func _on_select_card(index : int):
	emit_signal("completed", self, { "card_index": index })
