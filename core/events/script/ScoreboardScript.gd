extends ScriptEvent
class_name ScoreboardScriptEvent


func _execute(ctx : GameContext, inputs : Dictionary):
	object.call(func_name, ctx, inputs)
	get_tree().call_group("Scoreboard", "update_scoreboard", ctx.scoreboard.to_string())
	
	emit_signal("completed", self, {})
