extends Node2D
class_name Game

onready var game_queue : EventQueue
onready var replay_menu := $CanvasLayer/ReplayMenu

onready var table := $Table
onready var piles := $Table/Piles
onready var players := $Table/Players
onready var human := $Table/Players/You

export var num_players := 2

var game_ctx : GameContext


func _ready():
	position = Vector2()


func init_game():
	randomize()
	game_ctx = GameContext.new(table)
	
	reset()
	
	game_queue = build_game_queue()
	add_child(game_queue)
	
	init_scoreboard()
	get_tree().call_group("Scoreboard", "update_scoreboard", game_ctx.scoreboard.to_string())


func build_game_queue() -> EventQueue:
	return null


func init_scoreboard():
	pass
	

func create_ai_controller() -> Node:
	return preload("res://core/players/AIController.tscn").instance()


func reset():
	game_ctx.logs.clear()
	_update_console()
	
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
	game_queue.connect("completed", self, "_on_GameLoop_completed", [], CONNECT_ONESHOT)
	game_queue.execute(game_ctx, { "num_iter": 1 })


func _update_console():
	get_tree().call_group("Console", "update_logs", game_ctx.logs.to_string())


func _add_player(player : Player):
	player.clear_decks()
	game_ctx.players.append(player)


func _compare_players(a : Player, b : Player):
	return a.table_index < b.table_index


func _on_GameLoop_completed(_event, _outputs):
	game_ctx.logs.log_message("GAME OVER!")
	_update_console()
	
	replay_menu.show()
	

func _on_ReplayMenu_play_again():
	replay_menu.hide()
	
	reset()
	start()
