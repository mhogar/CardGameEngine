extends Player
class_name AIPlayer

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func select_card(deck : Deck):
	if deck is Hand:
		emit_signal("select_card", rng.randi() % deck.num_cards())
	else:
		emit_signal("select_card", deck.get_top_card_index())
