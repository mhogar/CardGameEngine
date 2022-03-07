extends Sprite

var back : Texture
var front : Texture


func _ready():
	back = texture


func create_front_texture(col : int, row : int):
	var atlas : Texture = preload("res://assets/cards.png")
	var card_width := atlas.get_width() / CardData.NUM_VALUES
	var card_height := atlas.get_height() / CardData.NUM_SUITS
	
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(col * card_width, row * card_height, card_width, card_height)

	front = tex


func set_face_up(face_up : bool):
	if face_up:
		texture = front
	else:
		texture = back
		
