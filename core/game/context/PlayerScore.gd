extends Resource
class_name PlayerScore

var scores := {}


func _init(players : Array):
	for player in players:
		scores[player.name] = 0
		

func set_value(player : String, score : int):
	scores[player] = score


func increment(player : String, amount : int = 1):
	scores[player] += amount


func decrement(player : String, amount : int = 1):
	increment(player, -amount)


func compare_descending(player1 : String, player2 : String):
	return scores[player1] > scores[player2]


func get_sorted_keys() -> Array:
	var keys := scores.keys()
	keys.sort_custom(self, "compare_descending")
	return keys
