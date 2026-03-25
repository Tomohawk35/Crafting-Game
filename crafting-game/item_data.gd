extends Resource
class_name ItemData

@export var item_name : String
@export var item_type : Constants.ItemType
@export var icon : Texture2D
@export var base_stats : StatsTable

#var item_type : ItemType = ItemType.WEAPON
#var rarity : Rarity = Rarity.COMMON
#var base_stats : Dictionary = {}
#var modifiers : Array = []
#var modifier_limit : int = 0 # proportional to rarity
#
#func _init(
	#_type : ItemType = ItemType.values().pick_random(), 
	#_rarity : Rarity = Rarity.COMMON
	#) -> void:
	#item_type = _type
	#rarity = _rarity
	#modifier_limit = rarity + 2
#
#func add_modifier(db: Dictionary) -> bool:
	#return false
#
#func print_item() -> void:
	#print("NEW ITEM")
	#print("TYPE: ", ItemType.keys()[item_type])
	#print("RARITY: ", Rarity.keys()[rarity])
	#print("MODIFIER LIMIT: ", modifier_limit)
