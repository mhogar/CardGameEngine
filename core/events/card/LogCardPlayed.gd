extends Event
class_name LogCardEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var index : int = inputs["card_index"]
	var player : Player = inputs["player"]
	
	get_tree().call_group("Console", "log_card_played", player, deck.get_card(index))
	emit_signal("completed", self, {})
