extends Event
class_name ConditionalEvent


func init(true_event : Event, false_event : Event):
	add_child(true_event)
	add_child(false_event)


func execute(ctx : GameContext, inputs : Dictionary):
	if apply_condition(ctx, inputs):
		execute_event(ctx, get_child(0), inputs)
	else:
		execute_event(ctx, get_child(1), inputs)


func execute_event(ctx : GameContext, event : Event, inputs : Dictionary):
	event.connect("completed", self, "_on_event_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	event.execute(ctx, merge_inputs(inputs, event.static_args))


func _on_event_completed(_event : Event, outputs : Dictionary):
	emit_signal("completed", self, outputs)
	

func apply_condition(_ctx : GameContext, _inputs : Dictionary) -> bool:
	return false
