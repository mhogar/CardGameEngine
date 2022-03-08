extends PlayerController
class_name AIController

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func select_card(_ctx : GameContext, _deck : Deck, indices : Array):
	emit_signal("select_card", indices[rng.randi() % indices.size()])
