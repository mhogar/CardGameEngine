extends Resource
class_name ScoreboardData

const SCORE_COLOUR := "red"

var scores := {}


func add_score(name : String, val : int = 0):
	scores[name] = val


func add_player_score(name : String, players : Array):
	scores[name] = PlayerScore.new(players)


func get_score(name : String) -> int:
	var tokens := name.split(":", true, 1)
	var score := tokens[0]

	if tokens.size() > 1:
		return scores[score].get_value(tokens[1])
	else:
		return scores[score]


func set_score(name : String, value : int):
	var tokens := name.split(":", true, 1)
	var score := tokens[0]
	
	if tokens.size() > 1:
		scores[score].set_value(tokens[1], value)
	else:
		scores[score] = value
	
		
func increment_score(name : String, amount : int = 1):
	var tokens := name.split(":", true, 1)
	var score := tokens[0]
	
	if tokens.size() > 1:
		scores[score].increment(tokens[1], amount)
	else:
		scores[score] += amount


func decrement_score(name : String, amount : int = 1):
	increment_score(name, -amount)


func to_string() -> String:
	var string := ""
	
	for name in scores:
		var score = scores[name]
		
		if score is PlayerScore:
			string += _player_score_to_string(name)
		else:
			string += _score_to_string(name)
			
		string += "\n"
		
	return string


func _score_to_string(name : String) -> String:
	return "[color=%s]%s:[/color] %d\n" % [SCORE_COLOUR, name, scores[name]]


func _player_score_to_string(name : String) -> String:
	var string := "[color=%s][u]%s[/u][/color]\n\n" % [SCORE_COLOUR, name]
		
	var cells := ""
	var color := "yellow"
	var sorted_keys : Array = scores[name].get_sorted_keys()
	
	for key in sorted_keys:
		cells += "[cell][color=%s]%s[/color][/cell][cell][color=%s]\t%s[/color][/cell]" % [color, key, color, scores[name].scores[key]]
		color = "white"
	
	string += "[table=2]%s[/table]\n" % cells
	return string
