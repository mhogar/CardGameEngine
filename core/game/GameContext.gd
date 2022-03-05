extends Node
class_name GameContext

var players := []
var piles := {}

var current_player_index := 0
var turn_dir := 1


func get_relative_player_index(index : int) -> int:
	return (current_player_index + index) % players.size()


func get_relative_player(index : int) -> Player:
	return players[get_relative_player_index(index)]
	

func next_turn():
	current_player_index = (current_player_index + turn_dir) % players.size()


func remove_player(index : int) -> Player:
	var player : Player = get_relative_player(index)
	players.erase(player)
	return player
