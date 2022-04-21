extends Event
class_name EventQueue

var num_iterations : int

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
	
	if current_event_index >= get_child_count():
		_pipeline_finished()
		return
		
	var event : Event = get_child(current_event_index)
	event.connect("completed", self, "_on_event_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	event.execute(game_ctx, next_inputs)


func _pipeline_finished():
	current_iter += 1
	
	if num_iterations < 1 || current_iter < num_iterations:
		_execute(game_ctx, init_inputs)
	else:
		_end_pipeline()


func _end_pipeline():
		current_iter = 0
		
		var queue_outputs := {}
		for captured_output in captured_outputs:
			queue_outputs[captured_output] = next_inputs[captured_output]
		
		if "break" in next_inputs && next_inputs["break"] > 1:
			queue_outputs["break"] = next_inputs["break"] - 1
		
		emit_signal("completed", self, queue_outputs)


func _on_event_completed(event : Event, outputs : Dictionary):	
	for key in outputs:
		next_inputs[key] = outputs[key]
		
	if "break" in next_inputs:
		_end_pipeline()
	else:
		_execute_next()
