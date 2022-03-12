extends Resource
class_name GameContext

var players := []
var piles := {}

var table : Node2D
var scoreboard : ScoreboardData
var logs : Logs

var current_player_index := 0
var turn_dir := 1


func _init(table : Node2D):
	scoreboard = ScoreboardData.new()
	logs = Logs.new()
	self.table = table


func get_relative_player_index(relative_index : int) -> int:
	return (current_player_index + relative_index) % players.size()


func get_relative_player(relative_index : int) -> Player:
	return players[get_relative_player_index(relative_index)]
	

func set_current_player_index(relative_index : int):
	current_player_index = (current_player_index + relative_index) % players.size()


func next_turn():
	set_current_player_index(turn_dir)
	

func set_turn(relative_index : int):
	set_current_player_index(relative_index)


func remove_player(relative_index : int) -> Player:
	var player_index := get_relative_player_index(relative_index)
	var player : Player = players[player_index]
	players.erase(player)

	if current_player_index >= player_index:	
		set_current_player_index(-1)
	
	return player
	

func add_player_score(name : String):
	scoreboard.add_player_score(name, players)
