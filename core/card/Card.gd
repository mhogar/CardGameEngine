extends Node2D
class_name Card

signal card_mouse_entered
signal card_mouse_exited

export(int, 12) var value : int
export(int, 3) var suit : int

onready var sprite := $Sprite
onready var anim_player := $AnimationPlayer
onready var collision_shape : RectangleShape2D = $Area2D/CollisionShape2D.shape

const NUM_VALUES := 13
const NUM_SUITS := 4

var face_up := false


func _ready():
	sprite.create_front_texture(value, suit)
	sprite.set_face_up(face_up)


func reset():
	sprite.position = Vector2()
	anim_player.stop()


func set_face_up(val : bool):
	face_up = val
	sprite.set_face_up(val)


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


func set_show_outline(val : bool):
	sprite.material.set_shader_param("show_outline", val)


func is_mouse_hovering():
	var mouse_pos := get_local_mouse_position()
	return abs(mouse_pos.x) <= collision_shape.extents.x && abs(mouse_pos.y) <= collision_shape.extents.y


func _on_Area2D_mouse_entered():
	emit_signal("card_mouse_entered")


func _on_Area2D_mouse_exited():
	emit_signal("card_mouse_exited")
