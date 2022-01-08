extends Event
class_name EventQueue

var events := []
var current_event_index : int


func add_event(event : Event):
	events.append(event)
	sub_events_node.add_child(event)


func execute(inputs : Array):
	current_event_index = -1
	execute_next(inputs)
	

func execute_next(inputs : Array):
	current_event_index += 1
	
	if current_event_index >= events.size():
		emit_signal("completed")
		return
	
	var event : Event = events[current_event_index]
	event.connect("completed", self, "_on_event_completed", [], CONNECT_ONESHOT)
	event.execute(inputs)


func _on_event_completed(outputs : Array):
	execute_next(outputs)
