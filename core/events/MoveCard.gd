extends Event
class_name MoveCardEvent

onready var tween := $Tween

var table : Node2D
var source_hand : Hand
var dest_deck : Deck
	

func execute():
	var select_card_event : SelectCardEvent = preload("res://core/events/SelectCard.tscn").instance()
	select_card_event.hand = source_hand
	
	select_card_event.connect("completed", self, "_on_select_card_completed")
	select_card_event.execute()


func _on_select_card_completed(index : int):
	var card := source_hand.remove_card(index)
	table.get_parent().add_child(card)
	
	card.position = table.transform.xform(source_hand.get_card_relative_position(card))
	card.reset_anims()
	
	tween.interpolate_property(card, "position", card.position, table.transform.xform(dest_deck.position), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [dest_deck, card])
	tween.start()


func _on_Tween_tween_all_completed(deck : Deck, card: Card):
	table.get_parent().remove_child(card)
	
	card.position = Vector2()
	deck.add_card(card)
	
	emit_signal("completed")
