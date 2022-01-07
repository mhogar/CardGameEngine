extends Event
class_name WaitAllEvent

var events := []
var completed := []
var outputs := []


func add_event(event : Event):
	event.connect("completed", self, "_on_event_completed", [events.size()])
	
	events.append(event)
	completed.append(false)
	outputs.append(null)


func execute():
	for event in events:
		event.execute()


func _on_event_completed(index : int, val):
	completed[index] = true
	outputs[index] = val
	
	if completed.find(false) < 0:
		emit_signal("completed", outputs)
