extends Spatial
class_name Card3D

signal flip_finished

onready var anim_player : AnimationPlayer = $AnimationPlayer

var face_up := true


func flip():
	if face_up:
		anim_player.play("Flip")
	else:
		anim_player.play_backwards("Flip")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Flip":
		face_up = !face_up
		emit_signal("flip_finished")
