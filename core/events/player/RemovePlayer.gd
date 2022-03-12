extends Event
class_name RemovePlayerEvent


func execute(ctx : GameContext, inputs : Dictionary):
	var player := ctx.remove_player(inputs["player_index"])
	emit_signal("completed", self, {})
