extends Event
class_name RemovePlayerEvent


func execute(ctx : GameContext, inputs : Dictionary):
	var player := ctx.remove_player(inputs["player_index"])
	get_tree().call_group("Console", "log_player_out", player)
	
	emit_signal("completed", self, {})
