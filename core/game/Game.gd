extends Node
class_name Game

signal queue_finished

onready var game_loop : EventQueue = $GameLoop
onready var players := $Table/Players
onready var piles := $Table/Piles

	
func init_game_state():
	for player in players.get_children():
		GameState.players.append(player)
		
	for pile in piles.get_children():
		GameState.piles[pile.deck_name] = pile


func start():
	game_loop.execute({ "num_iter": 1})


func _on_GameLoop_completed(_event, _outputs):
	emit_signal("queue_finished")
