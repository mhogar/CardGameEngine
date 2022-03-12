extends ScriptEvent
class_name LogScriptEvent


func execute(ctx : GameContext, inputs : Dictionary):
	object.call(func_name, ctx, inputs)
	get_tree().call_group("Console", "update_logs", ctx.logs.to_string())
	
	emit_signal("completed", self, {})
