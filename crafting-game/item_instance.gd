extends Resource
class_name ItemInstance

@export var base_item : ItemData
@export var rarity : Constants.Rarity
@export var quality : Constants.ItemQuality

@export var affixes : Array = []

var rolled_stats : Dictionary = {}

func get_color() -> Color:
	return Constants.RARITY_COLORS[rarity]

func get_display_name() -> String: 
	var n : String = Constants.ItemQuality.keys()[quality].capitalize() + " " + base_item.item_name
	return n
