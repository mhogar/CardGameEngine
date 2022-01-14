extends Node
class_name Game

signal queue_finished

onready var builder : EventQueueBuilder = $EventQueueBuilder
onready var table : Table = $Table
	

func start(inputs : Dictionary = {}):
	builder.event_queue.execute(inputs)


func _on_EventQueue_completed(event, outputs):
	emit_signal("queue_finished")
