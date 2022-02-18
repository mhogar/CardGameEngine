extends Event
class_name ApplyRulesetEvent


func execute(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	var ruleset : Ruleset = inputs["ruleset"]
	
	emit_signal("completed", self, { "selectable_indices": ruleset.calc_selectable_indices(ctx, deck) })
