extends Node2D
class_name Table

onready var human_player : HumanPlayer = $HumanPlayer

const TABLE_SPACE_SIZE := Vector2(0.4, 0.4)
const PLAYER_SPACE_SIZE := Vector2(1.0, 1.0) - TABLE_SPACE_SIZE

onready var players := [human_player]
var piles := []


func add_new_AI_player() -> AIPlayer:
	var ai : AIPlayer = preload("res://core/players/AI.tscn").instance()
	add_player(ai)
	return ai


func add_player(player : Player):
	players.append(player)
	add_child(player)


func add_new_pile(pos : Vector2) -> Pile:
	var pile : Pile = preload("res://core/deck/Pile.tscn").instance()
	pile.position = pos
	piles.append(pile)
	add_child(pile)
	return pile
	

func finalize(size : Vector2):
	size /= 2.0
	
	for pile in piles:
		pile.position *= size * TABLE_SPACE_SIZE

	position_players()
	for player in players:
		player.position *= size
	

func position_players():
	var layout := []
	if players.size() <= 2:
		layout = [0, 2]
	else:
		layout = [0, 1, 2, 3]
	
	for index in players.size():
		position_player(players[index], layout[index])


func position_player(player : Player, index : int):
	var table_pos := PLAYER_SPACE_SIZE / 2 + TABLE_SPACE_SIZE
	match(index):
		1:
			player.position = Vector2(-table_pos.x, 0.0)
			player.rotation_degrees = 90
		2:
			player.position = Vector2(0.0, -table_pos.y)
			player.rotation_degrees = 180
		3:
			player.position = Vector2(table_pos.x, 0.0)
			player.rotation_degrees = 270
		_:
			player.position = Vector2(0.0, table_pos.y)
			player.rotation_degrees = 0
