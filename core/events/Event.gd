extends Node
class_name Event

signal completed(event, outputs)

var static_args := {}

enum DECK_TYPE {
	SOURCE,
	DEST
}


func execute(ctx : GameContext, inputs : Dictionary):
	var full_inputs := inputs.duplicate()
	for key in static_args:
		full_inputs[key] = static_args[key]
	
	_execute(ctx, full_inputs)


func _execute(_ctx : GameContext, _inputs : Dictionary):
	emit_signal("completed", self, {})


func _resolve_deck_type(type : int) -> String:
	match type:
		DECK_TYPE.DEST:
			return "dest_deck"
		_: # SOURCE
			return "source_deck"
