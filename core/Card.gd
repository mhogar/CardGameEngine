extends Node2D
class_name Card

signal card_mouse_entered
signal card_mouse_exited

const NUM_VALUES := 13
const NUM_SUITS := 4

export(int, 12) var value : int
export(int, 3) var suit : int

onready var sprite := $Sprite
onready var anim_player := $AnimationPlayer


func _ready():
	var atlas : Texture = preload("res://assets/cards.png")
	var card_width := atlas.get_width() / NUM_VALUES
	var card_height := atlas.get_height() / NUM_SUITS
	
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(value * card_width, suit * card_height, card_width, card_height)
	
	sprite.texture = tex


func reset_anims():
	anim_player.stop()
	

func get_sprite_relative_position() -> Vector2:
	return transform.xform(sprite.position)


func play_hover_anim(backwards : bool = false):	
	if backwards:
		if anim_player.current_animation_position > 0:
			anim_player.play_backwards("Hover")
		else:
			anim_player.stop()
	else:
		anim_player.play("Hover")


func _on_Area2D_mouse_entered():
	emit_signal("card_mouse_entered")


func _on_Area2D_mouse_exited():
	emit_signal("card_mouse_exited")
