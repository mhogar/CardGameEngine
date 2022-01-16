extends Event
class_name EventQueue

onready var builder := $Builder
onready var events_node := $Events

var num_iterations := 1

var current_event_index : int
var current_iter : int

var init_inputs := {}
var next_inputs := {}


func add_event(event : Event, type : int, args : Dictionary):
	event.type = type
	event.static_args = args
	events_node.add_child(event)


func execute(init_inputs : Dictionary):
	if "num_iter" in init_inputs:
		num_iterations = init_inputs["num_iter"]
	
	current_event_index = -1
	init_inputs = init_inputs
	
	execute_next(init_inputs)
	

func execute_next(inputs : Dictionary):
	current_event_index += 1
	
	if current_event_index >= events_node.get_child_count():
		end_pipeline(inputs)
		return
		
	var event : Event = events_node.get_children()[current_event_index]
	next_inputs = merge_inputs(inputs, event.static_args)
	
	event.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event.execute(next_inputs)


func end_pipeline(outputs : Dictionary):
	current_iter += 1
	
	if current_iter >= num_iterations:
		current_iter = 0
		emit_signal("completed", self, outputs)
	else:
		execute(init_inputs)


func merge_inputs(inputs1 : Dictionary, inputs2 : Dictionary):
	for key in inputs2:
		inputs1[key] = inputs2[key]
		
	return inputs1


func _on_event_completed(event : Event, outputs : Dictionary):
	var inputs := {}
	
	if event.type == EventType.MERGE:
		inputs = merge_inputs(next_inputs, outputs)
	else:
		inputs = outputs
	
	execute_next(inputs)
