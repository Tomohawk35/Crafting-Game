extends Node

const SWORD : Resource = preload("uid://d0shki45u83sc")

@export var rarity_table : RarityTable = RarityTable.new()
@export var quality_table : ItemQualityTable =  ItemQualityTable.new()

func generate_item() -> ItemInstance:
	var item : ItemInstance = ItemInstance.new()
	item.base_item = SWORD
	item.rarity = rarity_table.roll_rarity()
	item.quality = quality_table.roll_quality()
	return item



# pick base type
# pick rarity
# does it have any mods
# assign random mods
