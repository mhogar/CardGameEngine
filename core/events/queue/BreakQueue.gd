extends Event
class_name BreakQueueEvent

var level : int


func _execute(_ctx : GameContext, _inputs : Dictionary):
	emit_signal("completed", self, { "break": level })
