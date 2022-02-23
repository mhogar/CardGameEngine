extends Spatial

onready var card : Card3D = $Card


func _ready():
	card.flip()


func _on_Card_flip_finished():
	card.flip()
