extends Resource
class_name AffixInstance

@export var affix_data : AffixData
@export var value : float

func roll_value() -> void:
	if affix_data.stat_name.ends_with("_pct"):
		value = randf_range(affix_data.min_value, affix_data.max_value)
	else:
		value = float(randi_range(affix_data.min_value, affix_data.max_value))
