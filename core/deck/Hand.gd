extends Deck
class_name Hand

onready var cards_node := $Cards
onready var outline := $Outline
onready var tween := $Tween

var max_width : float
var card_nodes := []
var hovered_card_indices := []


func _ready():
	var shape : RectangleShape2D = outline.shape
	max_width = shape.extents.x * 2


func adjust_spacing():
	tween.remove_all()
	
	var spacing := max_width / (num_cards() + 1)
	for card in card_nodes:
		var start_pos : float = card.position.x
		var new_pos : float = spacing * (card.z_index + 1) - (max_width / 2.0)
		
		tween.interpolate_property(card, "position:x", start_pos, new_pos, abs(start_pos - new_pos) / 500.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.start()


func select_card(index : int):
	var old_index := selected_card_index
	selected_card_index = index
	
	if old_index >= 0 && old_index < num_cards():
		card_nodes[old_index].play_hover_anim(true)
	
	if selected_card_index >= 0:
		card_nodes[index].play_hover_anim()


func unselect_card(index : int):
	hovered_card_indices.erase(index)
	if index != selected_card_index:
		return
		
	if hovered_card_indices.empty():
		select_card(-1)
	else:
		select_card(hovered_card_indices.max())


func get_card_global_position(index : int) -> Vector2:
	return get_global_transform().xform(card_nodes[index].get_sprite_relative_position())


func cards_shuffled():
	_recalculate_z_indices()


func card_added(index : int, data : CardData):
	var card : Card = preload("res://core/card/Card.tscn").instance()
	
	cards_node.add_child(card)
	card_nodes.insert(index, card)
	
	card.set_data(data)
	_recalculate_z_indices()
	adjust_spacing()
	
	card.connect("card_mouse_entered", self, "_on_card_mouse_entered", [card])
	card.connect("card_mouse_exited", self, "_on_card_mouse_exited", [card])


func card_removed(index : int, _data : CardData):
	var card : Card = card_nodes[index]
	
	cards_node.remove_child(card)
	card_nodes.remove(index)
	
	_recalculate_z_indices()
	adjust_spacing()
	unselect_card(index)
	
	card.disconnect("card_mouse_entered", self, "_on_card_mouse_entered")
	card.disconnect("card_mouse_exited", self, "_on_card_mouse_exited")


func set_show_card_outline(index : int, val : bool):
	card_nodes[index].set_show_outline(val)


func _recalculate_z_indices():
	for i in card_nodes.size():
		card_nodes[i].z_index = i

		
func _on_card_mouse_entered(card : Card):	
	var index := get_card_index(card.data)
	hovered_card_indices.append(index)
	
	if index > selected_card_index:
		select_card(index)
	

func _on_card_mouse_exited(card : Card):
	unselect_card(get_card_index(card.data))
