extends TextureRect
class_name CardUI

onready var anim_player : AnimationPlayer = $AnimationPlayer


func set_texture(tex : Texture):
	texture = tex


func _on_CardUI_mouse_entered():
	anim_player.play("Hover")
	
	
func _on_CardUI_mouse_exited():
	anim_player.play_backwards("Hover")
