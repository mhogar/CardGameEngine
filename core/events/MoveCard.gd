extends Event
class_name MoveCardEvent

onready var tween := $Tween


func execute(inputs : Dictionary):
	var source_deck : Deck = inputs["source_deck"]
	var dest_deck : Deck = inputs["dest_deck"]
	
	var card := source_deck.remove_card(inputs["card_index"])
	var player := get_player(source_deck)
	
	var table : Node2D
	if player != null:
		table = player.get_parent()
	else:
		table = source_deck.get_parent()
	
	table.add_child(card)
	var relative_pos := get_card_relative_position(source_deck, card)
	
	card.reset()
	card.position = relative_pos
	card.z_index = 1000
	
	tween.interpolate_property(card, "position", relative_pos, get_deck_relative_position(dest_deck), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed", [table, dest_deck, card], CONNECT_DEFERRED | CONNECT_ONESHOT)
	tween.start()


func get_player(deck : Deck) -> Player:
	var parent = deck.get_parent()
	if parent is Player:
		return parent
	
	return null


func get_deck_relative_position(deck : Deck) -> Vector2:
	var player := get_player(deck)
	if player != null:
		return player.transform.xform(deck.position)
	else:
		return deck.position


func get_card_relative_position(deck : Deck, card : Card) -> Vector2:
	var pos := deck.get_card_relative_position(card)
	
	var player := get_player(deck)
	if player != null:
		return player.transform.xform(pos)
	else:
		return pos


func _on_Tween_tween_all_completed(table : Node2D, deck : Deck, card: Card):
	table.remove_child(card)
	
	card.position = Vector2()
	deck.add_card(card)
	
	emit_signal("completed", self, {})
