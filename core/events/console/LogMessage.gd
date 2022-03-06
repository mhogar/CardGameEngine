extends Event
class_name LogMessageEvent


func execute(_ctx : GameContext, inputs : Dictionary):
	get_tree().call_group("Console", "log_message", inputs["log_message"])
	emit_signal("completed", self, {})
