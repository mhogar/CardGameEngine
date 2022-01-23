extends Node
class_name Event

signal completed(event, outputs)

enum EventType { MAP, MERGE}
export(EventType) var type : int = EventType.MAP

export(Dictionary) var static_args : Dictionary


func execute(inputs : Dictionary):
	pass
	

func merge_inputs(inputs1 : Dictionary, inputs2 : Dictionary):
	var new_inputs = inputs1.duplicate()
	
	for key in inputs2:
		new_inputs[key] = inputs2[key]
		
	return new_inputs
