extends HBoxContainer
class_name HandUI

var cards := []


func add_card(data : CardData):
	cards.push_back(data)
	
	var card : CardUI = preload("res://core/gui/CardUI.tscn").instance()
	
	add_child(card)
	card.set_texture(create_texture(data))


func create_texture(data : CardData) -> AtlasTexture:
	var atlas : Texture = preload("res://assets/cards.png")
	var card_width := atlas.get_width() / Card.NUM_VALUES
	var card_height := atlas.get_height() / Card.NUM_SUITS
	
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(data.value * card_width, data.suit * card_height, card_width, card_height)
	
	return tex
