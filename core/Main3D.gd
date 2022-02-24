extends Spatial

onready var hand : HandUI = $CanvasLayer/HandUI


func _ready():
	for i in range(5):
		hand.add_card(CardData.new(randi() % CardData.NUM_VALUES, randi() % CardData.NUM_SUITS))
