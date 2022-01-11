extends Event
class_name MoveCardEvent

onready var select_card_event := $SubEvents/SelectCard
onready var tween := $Tween


func execute(inputs : Dictionary):
	var source_deck : Deck = inputs["source_deck"]
	var dest_deck : Deck = inputs["dest_deck"]
	
	var card := source_deck.remove_card(inputs["card_index"])
	source_deck.get_parent().add_child(card)
	
	var relative_pos := source_deck.get_card_relative_position(card)
	
	card.reset()
	card.position = relative_pos
	card.z_index = 1000
	
	tween.interpolate_property(card, "position", relative_pos, dest_deck.position, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [dest_deck, card], CONNECT_ONESHOT)
	tween.start()


func _on_Tween_tween_all_completed(deck : Deck, card: Card):
	deck.get_parent().remove_child(card)
	
	card.position = Vector2()
	deck.add_card(card)
	
	emit_signal("completed", self, {})
