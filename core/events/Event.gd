extends Node
class_name Event

signal completed(event, outputs)

enum EventType { MAP, MERGE}
export(EventType) var type : int = EventType.MAP

export(Dictionary) var static_args : Dictionary
