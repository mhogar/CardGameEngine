extends Event
class_name NextTurnEvent


func _execute(ctx : GameContext, _inputs : Dictionary):
	ctx.next_turn()
	emit_signal("completed", self, {})
