extends Node
class_name Game

signal queue_finished

onready var event_queue : EventQueue = $EventQueue
onready var table : Table = $Table
	

func start(inputs : Dictionary = {}):
	event_queue.connect("completed", self, "_on_EventQueue_completed", [], CONNECT_ONESHOT)
	event_queue.execute(inputs)


func _on_EventQueue_completed(event, outputs):
	emit_signal("queue_finished")
