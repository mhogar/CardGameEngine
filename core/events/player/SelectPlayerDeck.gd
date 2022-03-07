extends SelectDeckEvent
class_name SelectPlayerDeckEvent

var deck_type : int


func execute(_ctx : GameContext, inputs : Dictionary):
	var player : Player = inputs["player"]
	var deck_name : String = inputs["deck_name"]
	
	emit_signal("completed", self, { resolve_deck_type(deck_type): player.decks[deck_name] })
