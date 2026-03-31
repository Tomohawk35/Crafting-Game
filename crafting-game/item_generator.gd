extends Node

const AFFIX_RATE : float = 0.4

@export var rarity_table : RarityTable = RarityTable.new()
@export var quality_table : ItemQualityTable =  ItemQualityTable.new()

func _get_affix_instance(affix_data: AffixData) -> AffixInstance:
	var a_inst : AffixInstance = AffixInstance.new()
	a_inst.affix_data = affix_data
	a_inst.roll_value()
	return a_inst

func generate_equipment() -> EquipmentInstance:
	var item : EquipmentInstance = EquipmentInstance.new()
	item.base_equipment = GameDB.BASE_ITEMS.pick_random()
	#item.quality = quality_table.roll_quality()
	item.affix_limit = 6
	
	for i in range(item.base_equipment.implicits.size()):
		var a_inst : AffixInstance = _get_affix_instance(item.base_equipment.implicits[i])
		item.implicit_affixes.append(a_inst)
	
	for i in range(item.affix_limit):
		var n : float = randf()
		if n >= AFFIX_RATE:
			var a : AffixData = GameDB.get_affixes_by_item_type(item.base_equipment.equipment_type).pick_random()
			var a_inst : AffixInstance = _get_affix_instance(a)
			item.explicit_affixes.append(a_inst)
	
	item.rarity = item.get_rarity()
	#item.get_rolled_stats()
	return item
