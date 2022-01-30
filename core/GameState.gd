extends Node

var players := []
var piles := {}

var current_player_index := 0


func get_relative_player(index : int = 0) -> Player:
	return players[(current_player_index + index) % players.size()]
