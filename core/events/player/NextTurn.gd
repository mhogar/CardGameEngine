extends Event
class_name NextTurnEvent


func execute(ctx : GameContext, _inputs : Dictionary):
	ctx.next_turn()
	emit_signal("completed", self, {})
