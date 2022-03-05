extends Resource
class_name PlayerScore

var scores := {}


func _init(players : Array):
	for player in players:
		scores[player.player_name] = 0
		

func set_value(player : Player, score : int):
	scores[player.player_name] = score


func increment(player : Player, amount : int = 1):
	scores[player.player_name] += amount


func decrement(player : Player, amount : int = 1):
	increment(player, -amount)
	

func to_string() -> String:
	var string := ""
	
	for player in scores:
		string += "%s\t%s\n" % [player, scores[player]]
		
	return string
