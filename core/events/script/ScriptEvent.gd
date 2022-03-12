extends Event
class_name ScriptEvent

var object : Object
var func_name : String


func execute(ctx : GameContext, inputs : Dictionary):
	var outputs : Dictionary = object.call(func_name, ctx, inputs)
	emit_signal("completed", self, outputs)
