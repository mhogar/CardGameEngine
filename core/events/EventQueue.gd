extends Event
class_name EventQueue

var num_iterations : int
var break_triggered := false

var current_event_index : int
var current_iter : int

var init_inputs := {}
var next_inputs := {}


func create_event(event : Event, args : Dictionary) -> Event:
	event.static_args = args
	return event


func add_event(event : Event, type : int):
	event.type = type
	add_child(event)


func map(event : Event):
	add_event(event, Event.EventType.MAP)

	
func merge(event : Event):
	add_event(event, Event.EventType.MERGE)


func execute(inputs : Dictionary):
	num_iterations = inputs["num_iter"]
	
	current_event_index = -1
	init_inputs = inputs
	
	execute_next(init_inputs)
	

func execute_next(inputs : Dictionary):
	current_event_index += 1
	
	if break_triggered || current_event_index >= get_child_count():
		end_pipeline(inputs)
		return
		
	var event : Event = get_child(current_event_index)
	next_inputs = merge_inputs(inputs, event.static_args)
	
	event.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event.execute(next_inputs)


func end_pipeline(outputs : Dictionary):
	current_iter += 1
	
	if !break_triggered && (num_iterations < 1 || current_iter < num_iterations):
		execute(init_inputs)
	else:
		current_iter = 0
		break_triggered = false
		emit_signal("completed", self, outputs)


func _on_event_completed(event : Event, outputs : Dictionary):
	var inputs := {}
	
	if event.type == EventType.MERGE:
		inputs = merge_inputs(next_inputs, outputs)
	else:
		inputs = outputs
	
	execute_next(inputs)
