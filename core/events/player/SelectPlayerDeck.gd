extends Event
class_name SelectPlayerDeckEvent

var deck_type : int


func execute(_ctx : GameContext, inputs : Dictionary):
	var player : Player = inputs["player"]
	var deck_name : String = inputs["deck_name"]
	
	emit_signal("completed", self, { _resolve_deck_type(deck_type): player.decks[deck_name] })
