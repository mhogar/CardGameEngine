extends Resource
class_name Logs

var logs := ""


func log_message(format : String, args : Array):
	var message := _format_message(format, args)
	logs += "> %s\n" % (message % args)


func clear():
	logs = ""


func to_string() -> String:
	return logs


func _format_message(format : String, args : Array) -> String:
	var index := 0
	
	for i in format.length():
		if format[i] == '%':
			match format[i+1]:
				'p': # player
					format[i+1] = 's'
					args[index] = args[index].to_bb_text()
				'x': # card
					format[i+1] = 's'
					args[index] = args[index].to_bb_text()
				'y': # suit
					format[i+1] = 's'
					args[index] = args[index].suit_to_bb_text()
				'z': # deck
					format[i+1] = 's'
					args[index] = args[index].to_bb_text()
			
			index += 1
	
	return format
