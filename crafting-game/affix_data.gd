extends Resource
class_name AffixData

# TODO: Create subtypes for added/increased/etc?
# TODO: Add item level requirement for affixes

@export var description : String
@export var stat_name : String
@export var tags : Array[String] = []
@export var item_types : Array[Constants.ItemType] = []

@export var min_value : float = 1
@export var max_value : float = 10

#func roll_value() -> float:
	#return randf_range(min_value, max_value)

# Adds %d physical damage
# %d%% increased physical damage
