extends PileCardSelector
class_name PlayerPileCardSelector

var card_hovered : bool
var top_card : Card


func _process(delta):
	if card_hovered && Input.is_action_just_pressed("confirm_card"):
		emit_signal("select_card", pile.get_top_card_index())


func start_select(deck : Deck):
	.start_select(deck)
	
	top_card = pile.get_top_card()
	top_card.set_show_outline(true)
	
	card_hovered = false
	top_card.connect("card_mouse_entered", self, "_on_card_mouse_entered")
	top_card.connect("card_mouse_exited", self, "_on_card_mouse_exited")


func end_select():
	top_card.set_show_outline(false)
	
	card_hovered = false
	top_card.disconnect("card_mouse_entered", self, "_on_card_mouse_entered")
	top_card.disconnect("card_mouse_exited", self, "_on_card_mouse_exited")


func _on_card_mouse_entered():
	card_hovered = true
	

func _on_card_mouse_exited():
	card_hovered = false
