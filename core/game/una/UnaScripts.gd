extends Node
class_name UnaScripts


func player_out_score(ctx : GameContext, inputs : Dictionary) -> Dictionary:
	var player := ctx.get_relative_player(inputs["player_index"])
	ctx.scoreboard.increment_score("Score:%s" % player.name, ctx.players.size() - 1)
	
	return {}
