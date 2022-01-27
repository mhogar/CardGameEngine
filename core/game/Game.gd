extends Node
class_name Game

signal queue_finished

onready var factory := $EventFactory
onready var event_queue : EventQueue = $GameLoop
onready var table : Table = $Table

var whitespace_regex := RegEx.new()

var actions := {
	"build_pile": ["pile"],
	"shuffle_pile": ["pile"],
	"deal_cards": ["pile", "int"],
	"move_top_card": ["pile", "pile", "bool"],
}	

	
func _ready():
	whitespace_regex.compile("\\s+")


func start():
	event_queue.execute({ "num_iter": 1})


func build_game(schematic : GameSchematic, num_players : int):	
	setup_table(schematic.table_layout, num_players)
	build_event_queue(schematic.event_script)


func setup_table(table_layout : Dictionary, num_players : int):
	for i in range(1, num_players):
		table.add_new_AI_player()
	
	for key in table_layout:
		table.add_new_pile(key, table_layout[key])
		
	table.finalize(get_viewport().size)


func build_event_queue(event_script : String):	
	for line in event_script.split("\n", false):
		if line[0] == '#':
			continue
		
		var tokens := whitespace_regex.sub(line, "", true).split(":")
		
		var action := tokens[0]
		if not action in actions:
			return "Invalid action %s" % action
		
		var args = parse_action(actions[action], tokens[1].split(","))
		if args == null:
			return "Invalid arguments for %s: %s" % [action, args]
			
		event_queue.map(factory.callv(action, args))
		

func parse_action(signature : Array, params : Array):
	var num_expected_params := signature.size()
	var num_given_params := params.size()
	
	if num_given_params < num_expected_params:
		return "Too few args (expected %d, got %d)" % [num_expected_params, num_given_params]
		
	if num_given_params > num_expected_params:
		return "Too many args (expected %d, got %d)" % [num_expected_params, num_given_params]
	
	var args := []
	for i in params.size():
		
		var param : String = params[i]
		var arg
		
		match signature[i]:
			"pile":
				arg = parse_pile(param)
			"int":
				arg = parse_int(param)
			"bool":
				arg = parse_bool(param)
		
		if arg == null:
			return "Invalid value at index %d" % i
		
		args.append(arg)
	
	return args


func parse_pile(name : String) -> Pile:
	if not name in GameState.piles:
		return null
	
	return GameState.piles[name]


func parse_int(val : String):
	var int_val := int(val)
	if int_val == 0 && val != "0":
		return null
		
	return int_val


func parse_bool(val : String):
	if val == "true":
		return true
	
	if val == "false":
		return false


func _on_GameLoop_completed(event, outputs):
	emit_signal("queue_finished")
