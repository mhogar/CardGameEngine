extends Spatial

onready var card : Card3D = $Card
onready var pile : Pile3D = $Pile


func _ready():
	card.flip()
	
	for i in range(52):
		var new_card : Card3D = preload("res://core/card/Card3D.tscn").instance()
		new_card.value = randi() % 13
		new_card.suit = randi() % 4
		
		pile.add_to_top(new_card)


func _on_Card_flip_finished():
	card.flip()
	#pile.remove_top().queue_free()
