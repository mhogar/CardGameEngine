extends Node2D
class_name Card

const NUM_VALUES := 13
const NUM_SUITS := 4

export(int, 12) var value : int
export(int, 3) var suit : int

onready var sprite := $Sprite


func _ready():
	var atlas : Texture = preload("res://assets/cards.png")
	var card_width := atlas.get_width() / NUM_VALUES
	var card_height := atlas.get_height() / NUM_SUITS
	
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(value * card_width, suit * card_height, card_width, card_height)
	
	sprite.texture = tex
