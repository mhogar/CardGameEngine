extends Event
class_name MoveCards

onready var tween := $Tween


func execute(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var last_index := deck.num_cards() - 2
	
	var delay := 0.0
	for index in range(last_index + 1):
		var event : Event = preload("res://core/events/card/MoveCard.tscn").instance()
		add_child(event)
		
		tween.interpolate_deferred_callback(event, delay, "execute", ctx, merge_inputs(inputs, { "card_index": 0 }))
		delay += 0.1
		
		if index == last_index:
			event.connect("completed", self, "_on_last_event_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	
	tween.start()


func _on_last_event_completed(_event : Event, _outputs : Dictionary):
	emit_signal("completed", self, {})
