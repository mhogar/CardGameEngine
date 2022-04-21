extends Node
class_name WizardScripts


func calc_num_rounds(ctx : GameContext, _inputs : Dictionary) -> Dictionary:
	return { "num_iter": ctx.piles["Deal Pile"].num_cards() / ctx.players.size() / 4 + 1 }


func select_winner(ctx : GameContext, _inputs : Dictionary) -> Dictionary:
	var play_pile : Pile = ctx.piles["Play Pile"]
	
	var active_suit := play_pile.get_card(0).suit
	var max_score := 0
	var winner := 0
	
	for index in play_pile.num_cards():
		var card := play_pile.get_card(index)
		
		if card.suit != active_suit:
			continue
			
		var score := card.value
		if score > max_score:
			max_score = score
			winner = index
	
	return { "player_index": winner }


func set_round_iterations(ctx : GameContext, _inputs : Dictionary) -> Dictionary:
	return { "num_iter": ctx.scoreboard.get_score("Round") }


func log_set_winner(ctx : GameContext, inputs : Dictionary):
	ctx.logs.log_message("%p won the set", [inputs["player"]])
	

func log_round_start(ctx : GameContext, _inputs : Dictionary):
	ctx.logs.log_message("Start of [color=fuchsia]Round %d[/color]" % ctx.scoreboard.get_score("Round"))


func log_round_over(ctx : GameContext, _inputs : Dictionary):
	ctx.logs.log_message("End of [color=fuchsia]Round %d[/color]" % ctx.scoreboard.get_score("Round"))
	

func score_set_winner(ctx : GameContext, inputs : Dictionary):
	ctx.scoreboard.increment_score("Round Score:" + inputs["player"].name, 10)
	
	
func score_round_end(ctx : GameContext, _inputs : Dictionary):
	ctx.scoreboard.increment_score("Round")
	
	for player in ctx.players:
		var score := ctx.scoreboard.get_score("Round Score:" + player.name)
		ctx.scoreboard.increment_score("Total Score:" + player.name, score)
		ctx.scoreboard.set_score("Round Score:" + player.name, 0)
