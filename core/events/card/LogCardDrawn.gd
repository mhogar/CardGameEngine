extends Event
class_name LogCardDrawnEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	var player : Player = inputs["player"]
	
	get_tree().call_group("Console", "log_card_drawn", player)
	emit_signal("completed", self, {})
