extends Player
class_name AIPlayer

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func select_card_hand(hand : Hand):
	emit_signal("select_card", rng.randi() % hand.num_cards())
	

func select_card_pile(pile : Pile):
	emit_signal("select_card", pile.get_top_card_index())
