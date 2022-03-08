extends Event
class_name SelectCardEvent


func execute(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var controller : PlayerController = inputs["player"].get_controller()
	var selectable_indices : Array = inputs["selectable_indices"]
	
	controller.connect("select_card", self, "_on_select_card", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	controller.select_card(ctx, deck, selectable_indices)
	

func _on_select_card(index : int):
	emit_signal("completed", self, { "card_index": index })
