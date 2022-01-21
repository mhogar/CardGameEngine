extends Deck
class_name Hand

onready var tween := $Tween

const MAX_WIDTH := 500.0

var hovered_card_indices := []


func adjust_spacing():
	tween.remove_all()
	
	var spacing := MAX_WIDTH / (cards.size() + 1)
	for i in cards.size():
		var card : Card = cards[i]
		
		var start_pos := card.position.x
		var new_pos : float = spacing * (i + 1) - (MAX_WIDTH / 2.0)
		
		tween.interpolate_property(card, "position:x", start_pos, new_pos, abs(start_pos - new_pos) / 500.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.start()


func on_card_added(card : Card):
	adjust_spacing()
	card.connect("card_mouse_entered", self, "_on_card_mouse_entered", [card])
	card.connect("card_mouse_exited", self, "_on_card_mouse_exited", [card])


func on_card_removed(index : int, card : Card):
	adjust_spacing()
	unselect_card(index)
	card.disconnect("card_mouse_entered", self, "_on_card_mouse_entered")
	card.disconnect("card_mouse_exited", self, "_on_card_mouse_exited")


func select_card(index : int):
	var old_index := selected_card_index
	selected_card_index = index
	
	if old_index >= 0 && old_index < cards.size():
		cards[old_index].play_hover_anim(true)
	
	if selected_card_index >= 0:
		cards[index].play_hover_anim()


func unselect_card(index : int):
	hovered_card_indices.erase(index)
	if index != selected_card_index:
		return
		
	if hovered_card_indices.empty():
		select_card(-1)
	else:
		select_card(hovered_card_indices.max())

		
func _on_card_mouse_entered(card : Card):
	var index := get_card_index(card)
	hovered_card_indices.append(index)
	
	if index > selected_card_index:
		select_card(index)
	

func _on_card_mouse_exited(card : Card):
	unselect_card(get_card_index(card))
