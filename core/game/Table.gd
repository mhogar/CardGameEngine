extends Node2D
class_name Table

onready var human_player : HumanPlayer = $HumanPlayer

var players := []
var piles := []


func _ready():
	add_player(human_player)


func add_new_AI_player() -> AIPlayer:
	var ai : AIPlayer = preload("res://core/players/AI/AI.tscn").instance()
	add_player(ai)
	return ai


func add_player(player : Player):
	players.append(player)
	add_child(player)


func add_new_pile() -> Pile:
	var pile : Pile = preload("res://core/Pile.tscn").instance()
	piles.append(pile)
	add_child(pile)
	return pile
	

func finalize(size : Vector2):
	pass
