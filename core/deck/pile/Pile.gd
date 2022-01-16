extends Deck
class_name Pile


func _on_Area2D_mouse_entered():
	emit_signal("selected_card_changed", self, get_top_card_index())


func _on_Area2D_mouse_exited():
	emit_signal("selected_card_changed", self, -1)
