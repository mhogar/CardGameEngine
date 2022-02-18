extends SelectDeckEvent
class_name SelectPlayerHandEvent

var deck_type : int


func execute(_ctx : GameContext, inputs : Dictionary):
	var player : Player = inputs["player"]
	emit_signal("completed", self, { resolve_deck_type(deck_type): player.hand })
