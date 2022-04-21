extends ConditionalEvent
class_name PlayersLeftCondition


func _apply_condition(ctx : GameContext, inputs : Dictionary) -> bool:
	return ctx.players.size() <= inputs["num_players"]
