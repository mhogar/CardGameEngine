extends Spatial
class_name Card3D

signal flip_finished

export(int, 12) var value : int
export(int, 3) var suit : int

onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var mesh : MeshInstance = $Card

const NUM_VALUES := 13
const NUM_SUITS := 4

var face_up := true


func _ready():
	assign_front_texture(value, suit)


func flip():
	if face_up:
		anim_player.play("Flip")
	else:
		anim_player.play_backwards("Flip")


func assign_front_texture(col : int, row : int):
	mesh["material/0"].uv1_offset = Vector3(float(col) / NUM_VALUES, float(row) / NUM_SUITS, 1.0)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Flip":
		face_up = !face_up
		emit_signal("flip_finished")
