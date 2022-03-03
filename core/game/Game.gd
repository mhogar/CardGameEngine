extends Node
class_name Game

onready var game_loop : EventQueue = $GameLoop
onready var replay_menu := $CanvasLayer/ReplayMenu
onready var players := $Table/Players
onready var piles := $Table/Piles

var game_ctx : GameContext


func init_game_context():
	game_ctx = GameContext.new()
	
	for player in players.get_children():
		game_ctx.players.append(player)
		
	for pile in piles.get_children():
		game_ctx.piles[pile.deck_name] = pile


func reset():
	for player in game_ctx.players:
		player.hand.clear()
	
	for key in game_ctx.piles:
		game_ctx.piles[key].clear()	


func start():
	randomize()
	game_loop.execute(game_ctx, { "num_iter": 1})


func _on_GameLoop_completed(_event, _outputs):
	replay_menu.show()
	

func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	reset()
	start()
