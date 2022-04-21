extends Event
class_name ApplyRulesetEvent

var ruleset : Ruleset


func _execute(ctx : GameContext, inputs : Dictionary):
	var deck : Deck = inputs["source_deck"]
	
	emit_signal("completed", self, { "selectable_indices": ruleset.calc_selectable_indices(ctx, deck) })
