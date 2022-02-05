extends Event
class_name SelectDeckEvent

enum DECK_TYPE {
	SOURCE,
	DEST
}


func resolve_deck_type(type : int) -> String:
	match type:
		DECK_TYPE.DEST:
			return "dest_deck"
		_: # SOURCE
			return "source_deck"
