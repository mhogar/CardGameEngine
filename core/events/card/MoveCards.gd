extends Event
class_name MoveCards

onready var tween := $Tween


func execute(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	
	var delay := 0.0
	for _index in range(deck.num_cards() - 1):
		var event := preload("res://core/events/card/MoveCard.tscn").instance()
		add_child(event)
		
		tween.interpolate_deferred_callback(event, delay, "execute", ctx, merge_inputs(inputs, { "card_index": 0 }))
		delay += 0.1
	
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	tween.start()


func _on_Tween_tween_all_completed():
	tween.remove_all()
	emit_signal("completed", self, {})
