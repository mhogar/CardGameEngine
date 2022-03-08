extends Node2D
class_name Game

onready var game_loop : EventQueue = $GameLoop
onready var replay_menu := $CanvasLayer/ReplayMenu

onready var table := $Table
onready var piles := $Table/Piles
onready var players := $Table/Players
onready var human := $Table/Players/You

export var num_players := 2

var game_ctx : GameContext


func _ready():
	position = Vector2()
	game_loop.connect("completed", self, "_on_GameLoop_completed")


func init_game():
	randomize()
	game_ctx = GameContext.new(table)
	
	reset()
	init_scoreboard()
	get_tree().call_group("Scoreboard", "update_scoreboard", game_ctx.scoreboard.to_string())


func init_scoreboard():
	pass
	

func create_ai_controller() -> Node:
	return preload("res://core/players/AIController.tscn").instance()


func reset():
	get_tree().call_group("Console", "clear_logs")
	
	game_ctx.players.clear()
	game_ctx.piles.clear()
	
	_add_player(human)
	
	for index in range(1, players.get_child_count()):
		var player : Player = players.get_child(index)
		
		if index >= num_players:
			player.queue_free()
			break
		
		var controller := create_ai_controller()
		controller.name = "Controller"
		
		player.add_child(controller)
		_add_player(player)
		
	game_ctx.players.sort_custom(self, "_compare_players")
		
	for pile in piles.get_children():
		pile.clear()
		game_ctx.piles[pile.name] = pile


func start():
	game_loop.execute(game_ctx, { "num_iter": 1})


func _add_player(player : Player):
	player.clear_decks()
	game_ctx.players.append(player)


func _compare_players(a : Player, b : Player):
	return a.table_index < b.table_index


func _on_GameLoop_completed(_event, _outputs):
	get_tree().call_group("Console", "log_message", "Game Over!")
	replay_menu.show()
	

func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	reset()
	start()
