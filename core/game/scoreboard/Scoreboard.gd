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


func update_scoreboard():
	var string := ""
	
	for name in scores:
		string += "[u]%s[/u]\n\n%s\n" % [name, scores[name].to_string()]
		
	print(string)
	
