extends Player
class_name AIPlayer

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func select_card(deck : Deck, indices : Array):
	emit_signal("select_card", indices[rng.randi() % indices.size()])
