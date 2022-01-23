extends ConditionalEvent
class_name HasSelectableIndicesCondition


func apply_condition(inputs : Dictionary) -> bool:
	var selectable_indices : Array = inputs["selectable_indices"]
	return !selectable_indices.empty()
