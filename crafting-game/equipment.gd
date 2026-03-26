extends Resource
class_name Equipment

signal stats_updated

@export var base_item : ItemData
@export var rarity : Constants.Rarity
@export var quality : Constants.ItemQuality

@export var affixes : Array[AffixInstance] = []

var affix_limit : int
var rolled_stats : Dictionary = {}
var final_stats : Dictionary = {}

func get_rarity() -> Constants.Rarity:
	match affixes.size():
		0:
			return Constants.Rarity.COMMON
		1, 2:
			return Constants.Rarity.UNCOMMON
		3, 4, 5:
			return Constants.Rarity.RARE
		_:
			return Constants.Rarity.LEGENDARY

func get_color() -> Color:
	return Constants.RARITY_COLORS[rarity]

func get_display_name() -> String: 
	var n : String = Constants.ItemQuality.keys()[quality].capitalize() + " " + base_item.item_name
	return n

func get_rolled_stats() -> void:
	rolled_stats.clear()
	
	if affixes.is_empty():
		return
	
	for affix_instance in affixes:
		if rolled_stats.has(affix_instance.affix_data.stat_name):
			rolled_stats[affix_instance.affix_data.stat_name] += affix_instance.value
		else:
			rolled_stats[affix_instance.affix_data.stat_name] = affix_instance.value
	
	stats_updated.emit()

func calculate_final_stats() -> void:
	# (Base + Added) * (1.0 + Increased / 100)
	
	pass

func add_affix(affix: AffixData = null) -> void:
	if affixes.size() >= affix_limit:
		return
	#var a : AffixData = GameDB.get_affixes_by_item_type(base_item.item_type).pick_random()
	var a_inst : AffixInstance = AffixInstance.new()
	if affix:
		a_inst.affix_data = affix
	else:
		var a : AffixData = GameDB.get_affixes_by_item_type(base_item.item_type).pick_random()
		if a:
			a_inst.affix_data = a
		else:
			return
	
	a_inst.roll_value()
	affixes.append(a_inst)
	get_rolled_stats() 
