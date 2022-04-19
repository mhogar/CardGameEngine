extends Event
class_name LoopNumPlayersEvent


func _execute(ctx : GameContext, _inputs : Dictionary):
	emit_signal("completed", self, { "num_iter": ctx.players.size() })
