extends Node
class_name StandardLogScripts


func reshuffled_deck(ctx : GameContext, inputs : Dictionary):
	ctx.logs.log_message("Reshuffled %z", [inputs["source_deck"]])


func card_drawn(ctx : GameContext, inputs : Dictionary):
	ctx.logs.log_message("%p drew a card", [inputs["player"]])
	

func card_played(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var index : int = inputs["card_index"]
	var player : Player = inputs["player"]
	
	ctx.logs.log_message("%p played %x", [player, deck.get_card(index)])
	

func player_out(ctx : GameContext, inputs : Dictionary):
	ctx.logs.log_message("%p is out!", [inputs["player"]])
