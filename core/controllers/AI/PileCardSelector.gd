extends PileCardSelector
class_name AIPileCardSelector


func start_select():
	emit_signal("select_card", pile.get_top_card_index())
