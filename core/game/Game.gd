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
	get_tree().call_group("Console", "clear_logs")
	game_ctx = GameContext.new()
	
	for player in players.get_children():
		player.hand.clear()
		game_ctx.players.append(player)
		
	for pile in piles.get_children():
		pile.clear()
		game_ctx.piles[pile.deck_name] = pile


func start():
	game_loop.execute(game_ctx, { "num_iter": 1})


func _on_GameLoop_completed(_event, _outputs):
	replay_menu.show()
	

func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	init_game()
	start()
