extends Resource
class_name AffixData

# TODO: Create subtypes for added/increased/etc?
# TODO: Add item level requirement for affixes
# TODO: Add weight for affix

@export var description : String
@export var stat_name : String
@export var tags : Array[String] = [] # HACK: Is this necessary?
@export var equipment_types : Array[Constants.EquipmentType] = []

@export var min_value : float = 1
@export var max_value : float = 10
