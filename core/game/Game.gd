extends Node
class_name Game

signal queue_finished

onready var event_queue : GameEventQueue = $GameLoop
onready var table : Table = $Table
	

func start():
	event_queue.connect("completed", self, "_on_EventQueue_completed", [], CONNECT_ONESHOT)
	event_queue.execute({ "num_iter": 1})


func _on_EventQueue_completed(event, outputs):
	emit_signal("queue_finished")
