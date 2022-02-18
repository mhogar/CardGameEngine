extends Event
class_name SelectPlayerEvent


func execute(ctx : GameContext, inputs : Dictionary):
	var index : int = inputs["player_index"]
	emit_signal("completed", self, { "player": ctx.get_relative_player(index) })
