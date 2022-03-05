extends Node2D
class_name Game

onready var game_loop : EventQueue = $GameLoop
onready var replay_menu := $CanvasLayer/ReplayMenu
onready var players := $Table/Players
onready var piles := $Table/Piles

var game_ctx : GameContext


func _ready():
	position = Vector2()


func init_game():
	randomize()
	game_ctx = GameContext.new()
	
	reset()

	init_scoreboard()
	get_tree().call_group("Scoreboard", "update_scoreboard", game_ctx.scoreboard.to_string())


func init_scoreboard():
	pass


func reset():
	get_tree().call_group("Console", "clear_logs")
	
	game_ctx.players.clear()
	for player in players.get_children():
		player.hand.clear()
		game_ctx.players.append(player)
		
	game_ctx.piles.clear()
	for pile in piles.get_children():
		pile.clear()
		game_ctx.piles[pile.deck_name] = pile


func start():
	game_loop.execute(game_ctx, { "num_iter": 1})


func _on_GameLoop_completed(_event, _outputs):
	replay_menu.show()
	

func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	reset()
	start()
