extends PlayerController
class_name AIController

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func select_card(ctx : GameContext, deck : Deck, indices : Array):
	emit_signal("select_card", select_index(ctx, deck, indices))


func select_index(_ctx : GameContext, _deck : Deck, indices : Array) -> int:
	return indices[rng.randi() % indices.size()]
