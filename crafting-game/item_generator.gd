extends Node

const SWORD : Resource = preload("uid://d0shki45u83sc")
const AFFIX_RATE : float = 0.4

@export var rarity_table : RarityTable = RarityTable.new()
@export var quality_table : ItemQualityTable =  ItemQualityTable.new()

func generate_item() -> ItemInstance:
	var item : ItemInstance = ItemInstance.new()
	item.base_item = SWORD
	item.quality = quality_table.roll_quality()
	item.affix_limit = item.quality
	
	for i in range(item.affix_limit):
		var n : float = randf()
		if n >= AFFIX_RATE:
			var a : AffixData = GameDB.get_affixes_by_item_type(item.base_item.item_type).pick_random()
			var a_inst : AffixInstance = AffixInstance.new()
			a_inst.affix_data = a
			a_inst.roll_value()
			item.affixes.append(a_inst)
	
	item.rarity = item.get_rarity()
	item.get_rolled_stats()
	return item
