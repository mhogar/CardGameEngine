extends Event
class_name EventQueue

onready var events_node := $Events

var current_event_index : int
var inputs := {}


func add_event(event : Event, type : int, args : Dictionary):
	event.type = type
	event.static_args = args
	events_node.add_child(event)


func execute(init_inputs : Dictionary):
	current_event_index = -1
	execute_next(init_inputs)
	

func execute_next(next_inputs : Dictionary):
	current_event_index += 1
	
	if current_event_index >= events_node.get_child_count():
		emit_signal("completed", self, next_inputs)
		return
		
	var event : Event = events_node.get_children()[current_event_index]
	inputs = merge_inputs(next_inputs, event.static_args)
	
	event.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event.execute(inputs)


func merge_inputs(inputs1 : Dictionary, inputs2 : Dictionary):
	for key in inputs2:
		inputs1[key] = inputs2[key]
		
	return inputs1


func _on_event_completed(event : Event, outputs : Dictionary):
	var next_inputs := {}
	
	if event.type == EventType.MERGE:
		next_inputs = merge_inputs(inputs, outputs)
	else:
		next_inputs = outputs
	
	execute_next(next_inputs)
