extends Event
class_name ConditionalEvent


func init(true_event : Event, false_event : Event):
	add_child(true_event)
	add_child(false_event)


func _execute(ctx : GameContext, inputs : Dictionary):
	if _apply_condition(ctx, inputs):
		_execute_event(ctx, get_child(0), inputs)
	else:
		_execute_event(ctx, get_child(1), inputs)


func _execute_event(ctx : GameContext, event : Event, inputs : Dictionary):
	event.connect("completed", self, "_on_event_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	event.execute(ctx, inputs)


func _on_event_completed(_event : Event, outputs : Dictionary):
	emit_signal("completed", self, outputs)
	

func _apply_condition(_ctx : GameContext, _inputs : Dictionary) -> bool:
	return false
