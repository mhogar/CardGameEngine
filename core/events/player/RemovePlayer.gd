extends Event
class_name RemovePlayerEvent


func _execute(ctx : GameContext, inputs : Dictionary):
	var player := ctx.remove_player(inputs["player_index"])
	emit_signal("completed", self, {})
