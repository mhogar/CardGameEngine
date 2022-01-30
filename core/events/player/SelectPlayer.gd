extends Event
class_name SelectPlayerEvent


func execute(inputs : Dictionary):
	var index : int = inputs["player_index"]
	emit_signal("completed", self, { "player": GameState.get_relative_player(index) })
