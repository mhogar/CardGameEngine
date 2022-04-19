extends Event
class_name SetTurnEvent


func execute(ctx : GameContext, inputs : Dictionary):
	ctx.set_turn(inputs["player_index"])
	emit_signal("completed", self, {})
