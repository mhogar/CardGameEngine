extends Resource
class_name GameSchematic

export(int, 1, 4) var min_players := 1
export(int, 1, 4) var max_players := 4

export var table_layout := {}
export(String, MULTILINE) var event_script := ""
