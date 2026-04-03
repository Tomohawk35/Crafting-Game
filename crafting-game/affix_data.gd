extends Resource
class_name AffixData

# TODO: Create subtypes for added/increased/etc?
# TODO: Add item level requirement for affixes
# TODO: Add weight for affix

@export var description : String
@export var stat_name : String
@export var tags : Array[String] = [] # HACK: Is this necessary?
@export var equipment_types : Dictionary[Constants.EquipmentType, bool] = {
	Constants.EquipmentType.WEAPON : false,
	Constants.EquipmentType.BODY_ARMOR : false,
	Constants.EquipmentType.SHIELD : false,
	Constants.EquipmentType.HELMET : false,
	Constants.EquipmentType.RING : false,
	Constants.EquipmentType.AMULET : false
}
@export var weight : int = 500

@export var min_value : float = 1
@export var max_value : float = 10
