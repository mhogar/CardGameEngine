extends Resource
class_name GameSchematic

export(int, 1, 4) var min_players := 1
export(int, 1, 4) var max_players := 4

export var table_layout := {}
export(String, MULTILINE) var event_script := ""

var factory := EventFactory.new()
var regex := RegEx.new()

var actions := {
	"build_pile": ["pile"],
	"shuffle_pile": ["pile"],
	"deal_cards": ["pile", "int"],
	"move_top_card": ["pile", "pile", "bool"],
}


func _init():
	regex.compile("\\s+")


func setup_table(table : Table, num_players : int):
	for i in range(1, num_players):
		table.add_new_AI_player()
	
	for key in table_layout:
		table.add_new_pile(key, table_layout[key])


func build_event_queue(queue : EventQueue):	
	for line in event_script.split("\n", false):
		if line[0] == '#':
			continue
		
		var tokens := regex.sub(line, "", true).split(":")
		var action := tokens[0]
		var args := parse_action(action, tokens[1].split(","))
		
		if args.empty():
			return
			
		queue.map(factory.callv(action, args))
		

func parse_action(action : String, params : PoolStringArray) -> Array:
	if not action in actions:
		print("Invalid action: ", action)
		return []
	print("Action: ", action)
	
	var signature : Array = actions[action]
	if signature.size() != params.size():
		print("Invalid number of args")
		return []
	
	var args := []
	for i in params.size():
		var arg
		var param := params[i]
		
		match signature[i]:
			"pile":
				arg = parse_pile(param)
			"int":
				arg = int(param)
			"bool":
				arg = parse_bool(param)
		
		if arg == null:
			print("Invalid argument value: ", i)
			return []
		
		args.append(arg)
	
	return args


func parse_pile(name : String) -> Pile:
	if not name in GameState.piles:
		return null
	
	return GameState.piles[name]
	

func parse_bool(val : String) -> bool:
	return val == "true"
