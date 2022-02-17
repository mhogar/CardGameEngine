extends Node
#class_name GameState

var players := []
var piles := {}

var current_player_index := 0
var turn_dir := 1


func get_relative_player(index : int = 0) -> Player:
	return players[(current_player_index + index) % players.size()]
	

func next_turn():
	current_player_index = (current_player_index + turn_dir) % players.size()
