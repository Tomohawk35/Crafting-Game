extends Resource
class_name EquipmentInstance

# TODO: Include a tier/level for equipment?
signal stats_updated

@export var base_equipment : Equipment
@export var implicit_affixes : Array[AffixInstance] = []
@export var explicit_affixes : Array[AffixInstance] = []
@export var affix_limit : int
@export var rarity : Constants.Rarity
@export var total_stats : Dictionary

func _update_stats() -> void:
	rarity = get_rarity()
	total_stats = {}
	for a in implicit_affixes:
		if total_stats.has(a.affix_data.stat_name):
			total_stats[a.affix_data.stat_name] += a.value
		else:
			total_stats[a.affix_data.stat_name] = a.value
	for a in explicit_affixes:
		if total_stats.has(a.affix_data.stat_name):
			total_stats[a.affix_data.stat_name] += a.value
		else:
			total_stats[a.affix_data.stat_name] = a.value
	stats_updated.emit()

func get_rarity() -> Constants.Rarity:
	match explicit_affixes.size():
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

func add_affix() -> void:
	if explicit_affixes.size() >= affix_limit:
		return
	var possible_affixes : Array[AffixData] = GameDB.get_affixes_by_item_type(base_equipment.equipment_type)
	if possible_affixes.is_empty():
		return
	var a_inst : AffixInstance = AffixInstance.new()
	a_inst.affix_data = possible_affixes.pick_random()
	a_inst.roll_value()
	explicit_affixes.append(a_inst)
	_update_stats()

func remove_affix() -> void:
	if explicit_affixes.size() <= 0:
		return
	var a : AffixInstance = explicit_affixes.pick_random()
	explicit_affixes.erase(a)
	_update_stats()
