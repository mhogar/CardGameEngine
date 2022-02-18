extends Node
class_name Game

signal queue_finished

onready var game_loop : EventQueue = $GameLoop
onready var players := $Table/Players
onready var piles := $Table/Piles

var game_ctx : GameContext

	
func init_game_context():
	game_ctx = load("res://core/game/GameContext.gd").new()
	
	for player in players.get_children():
		game_ctx.players.append(player)
		
	for pile in piles.get_children():
		game_ctx.piles[pile.deck_name] = pile


func start():
	game_loop.execute(game_ctx, { "num_iter": 1})


func _on_GameLoop_completed(_event, _outputs):
	emit_signal("queue_finished")
