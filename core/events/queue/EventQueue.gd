extends Event
class_name EventQueue

var num_iterations : int
var break_triggered := false

var current_event_index : int
var current_iter : int
var next_inputs := {}

var game_ctx : GameContext
var init_inputs := {}

var captured_outputs := []


func add_event(event : Event, args : Dictionary):
	event.static_args = args
	add_child(event)


func _execute(ctx : GameContext, inputs : Dictionary):
	game_ctx = ctx
	init_inputs = inputs.duplicate()
	next_inputs = inputs
	
	num_iterations = inputs["num_iter"]
	current_event_index = -1
	
	_execute_next()
	

func _execute_next():
	current_event_index += 1
	
	if break_triggered || current_event_index >= get_child_count():
		_end_pipeline(next_inputs)
		return
		
	var event : Event = get_child(current_event_index)
	event.connect("completed", self, "_on_event_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	event.execute(game_ctx, next_inputs)


func _end_pipeline(outputs : Dictionary):
	current_iter += 1
	
	if !break_triggered && (num_iterations < 1 || current_iter < num_iterations):
		_execute(game_ctx, init_inputs)
	else:
		current_iter = 0
		break_triggered = false
		
		var queue_outputs := {}
		for captured_output in captured_outputs:
			queue_outputs[captured_output] = outputs[captured_output]
		
		emit_signal("completed", self, queue_outputs)


func _on_event_completed(event : Event, outputs : Dictionary):
	for key in outputs:
		next_inputs[key] = outputs[key]
	
	_execute_next()
