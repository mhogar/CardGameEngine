extends Event
class_name BreakQueueEvent

var target_queue : EventQueue


func execute(_inputs : Dictionary):
	target_queue.break_triggered = true
	emit_signal("completed", self, {})