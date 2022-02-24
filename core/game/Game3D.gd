extends Spatial

onready var card : Card3D = $Card
onready var pile : Pile3D = $Pile


func _ready():
	card.set_data(CardData.new(7, 2))
	card.flip()
	
	for i in range(32):
		pile.add_to_top(CardData.new(randi() % CardData.NUM_VALUES, randi() % CardData.NUM_SUITS))


#func _physics_process(_delta):
#	print(Performance.get_monitor(Performance.TIME_FPS))


func _on_Card_flip_finished():
	card.flip()
	#pile.remove_top().queue_free()
