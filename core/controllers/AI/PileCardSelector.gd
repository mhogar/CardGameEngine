extends PileCardSelector
class_name AIPileCardSelector


func start_select(deck : Deck):
	.start_select(deck)
	emit_signal("select_card", pile.get_top_card_index())
