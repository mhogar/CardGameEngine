extends Resource
class_name ScoreboardData

var scores := {}


func add_player_score(name : String, players : Array):
	scores[name] = PlayerScore.new(players)


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
		string += "[color=red][u]%s[/u][/color]\n\n" % name
		
		var cells := ""
		var color := "yellow"
		var sorted_keys : Array = scores[name].get_sorted_keys()
		
		for key in sorted_keys:
			cells += "[cell][color=%s]%s[/color][/cell][cell][color=%s]\t%s[/color][/cell]" % [color, key, color, scores[name].scores[key]]
			color = "white"
		
		string += "[table=2]%s[/table]\n" % cells
		
	return string
