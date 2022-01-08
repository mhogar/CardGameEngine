extends Node

var uid := 0


func next_uid() -> int:
	uid += 1
	return uid
