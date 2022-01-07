extends Deck
class_name Hand

signal select_card

const MAX_WIDTH := 500.0

var hovered_card_indices := []
var selected_card_index : int = -1


func _ready():
	create_hand(10)
	
	var spacing := MAX_WIDTH / (num_cards() + 1)
	for i in num_cards():
		get_cards()[i].position.x = spacing * (i + 1) - (MAX_WIDTH / 2.0)


func _process(delta):
	if Input.is_action_just_pressed("confirm_card") && selected_card_index >= 0:
		emit_signal("select_card", selected_card_index)


func create_hand(num_cards : int):
	for i in num_cards:
		var card : Card = preload("res://core/Card.tscn").instance()
		card.value = randi() % Card.NUM_VALUES
		card.suit = randi() % Card.NUM_SUITS

		card.connect("card_mouse_entered", self, "_on_card_mouse_entered", [card])
		card.connect("card_mouse_exited", self, "_on_card_mouse_exited", [card])
		cards_node.add_child(card)


func remove_card(index : int) -> Card:
	unselect_card(index)
	return .remove_card(index)


func select_card(index : int):
	var old_index := selected_card_index
	selected_card_index = index
	
	if index >= 0:
		get_cards()[index].play_hover_anim()
	
	if old_index >= 0:
		get_cards()[old_index].play_hover_anim(true)


func unselect_card(index : int):
	hovered_card_indices.erase(index)
	if index != selected_card_index:
		return
		
	if hovered_card_indices.empty():
		select_card(-1)
	else:
		select_card(hovered_card_indices.max())

		
func _on_card_mouse_entered(card : Card):
	var index := get_cards().find(card)
	hovered_card_indices.append(index)
	
	if index > selected_card_index:
		select_card(index)
	

func _on_card_mouse_exited(card : Card):
	unselect_card(get_cards().find(card))

