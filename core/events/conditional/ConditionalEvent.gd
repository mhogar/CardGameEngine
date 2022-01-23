extends Event
class_name ConditionalEvent


func init(true_event : Event, false_event : Event):
	add_child(true_event)
	add_child(false_event)


func execute(inputs : Dictionary):	
	if apply_condition(inputs):
		execute_event(get_child(0), inputs)
	else:
		execute_event(get_child(1), inputs)


func execute_event(event : Event, inputs : Dictionary):
	event.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event.execute(merge_inputs(inputs, event.static_args))


func _on_event_completed(event : Event, outputs : Dictionary):
	emit_signal("completed", self, outputs)
	

func apply_condition(inputs : Dictionary) -> bool:
	return false
