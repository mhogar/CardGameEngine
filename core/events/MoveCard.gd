extends Event
class_name MoveCardEvent

onready var select_card_event := $SubEvents/SelectCard
onready var tween := $Tween

var table : Node2D
var source_deck : Deck
var dest_deck : Deck


func execute(inputs : Array):
	var card := source_deck.remove_card(inputs[0])
	table.get_parent().add_child(card)
	
	card.position = table.transform.xform(source_deck.get_card_relative_position(card))
	card.reset()
	
	tween.interpolate_property(card, "position", card.position, table.transform.xform(dest_deck.position), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [dest_deck, card], CONNECT_ONESHOT)
	tween.start()


func _on_Tween_tween_all_completed(deck : Deck, card: Card):	
	table.get_parent().remove_child(card)
	
	card.position = Vector2()
	deck.add_card(card)
	
	emit_signal("completed", [])
