extends Event
class_name MoveCardEvent

onready var tween := $Tween
onready var stream_player := $AudioStreamPlayer

var sounds := []


func _ready():
	sounds.append(preload("res://assets/sounds/card/play1.wav"))
	sounds.append(preload("res://assets/sounds/card/play2.wav"))
	sounds.append(preload("res://assets/sounds/card/play3.wav"))
	sounds.append(preload("res://assets/sounds/card/play4.wav"))


func _execute(ctx : GameContext, inputs : Dictionary):
	var source_deck : Deck = inputs["source_deck"]
	var dest_deck : Deck = inputs["dest_deck"]
	var index : int = inputs["card_index"]
	
	var card : Card = preload("res://core/card/Card.tscn").instance()
	card.position = source_deck.get_card_global_position(index)
	card.z_index = 1000
	ctx.table.add_child(card)
	
	var data := source_deck.remove_card(index)
	card.set_data(data)
	card.set_face_up(dest_deck.is_face_up)
	
	tween.interpolate_property(card, "position", card.position, dest_deck.get_global_position(), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [dest_deck, card], CONNECT_DEFERRED | CONNECT_ONESHOT)
	tween.start()
	
	stream_player.stream = sounds[randi() % sounds.size()]
	stream_player.play()


func _on_Tween_tween_all_completed(deck : Deck, card: Card):
	deck.add_card(card.data)
	card.queue_free()
	
	emit_signal("completed", self, {})
