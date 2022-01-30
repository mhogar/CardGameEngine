extends Event
class_name NextTurnEvent


func execute(inputs : Dictionary):
	GameState.next_turn()
	emit_signal("completed", self, {})
