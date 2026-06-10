extends Item
class_name Equipment

# TODO: Include a tier/level for equipment?
signal stats_updated

#@export var base_equipment : Equipment
@export var equipment_type : Constants.EquipmentType
@export var implicit_affixes : Array[AffixInstance] = []
@export var explicit_affixes : Array[AffixInstance] = []
@export var affix_limit : int
@export var rarity : Constants.Rarity
@export var total_stats : StatsTable
@export var description_string : String = ""

func _update_stats() -> void:
	rarity = get_rarity()
	total_stats = StatsTable.new()
	#description_string = "[center][b][color=red]%s[/color][/b][/center]" % item_name
	description_string = ""
	
	#for a in implicit_affixes:
		#total_stats.stats[a.affix_data.stat_name] += a.value
		#description_string += "%s\n" % _format_stat(a.affix_data.stat_name, a.value)
	for a in explicit_affixes:
		total_stats.stats[a.affix_data.stat_name] += a.value
		#description_string = "%s\n%s" % [description_string, _format_stat(a.affix_data.stat_name, a.value)]
		description_string += _format_stat(a.affix_data.stat_name, a.value)
		#append_string(description_string) += _format_stat(a.affix_data.stat_name, a.value)
		#description_string.
	
	stats_updated.emit()


func _format_stat(stat_name: String, value: float) -> String:
	var display : String = stat_name.replace("_", " ").capitalize()
	
	if stat_name.ends_with("_pct"):
		if value > 0:
			return "%.2f%% Increased %s" % [value, display.replace(" Pct", "")]
		else:
			return "%d%% Decreased %s" % [value, display.replace(" Pct", "")]
	
	if value > 0:
		return "+%d %s" % [round(value), display]
	else:
		return "-%d %s" % [round(value), display]

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

func add_affix() -> bool:
	if explicit_affixes.size() >= affix_limit:
		print("At affix limit. Cannot add affix.")
		return false
	
	var possible_affixes : Array[AffixData] = GameDB.get_affixes_by_item_type(equipment_type)
	if possible_affixes.is_empty():
		print("No possible affixes.")
		return false
	
	var a_inst : AffixInstance = AffixInstance.new()
	a_inst.affix_data = possible_affixes.pick_random()
	a_inst.roll_value()
	explicit_affixes.append(a_inst)
	_update_stats()
	print("Affix added!")
	return true

func clear_explicit_affixes() -> bool:
	explicit_affixes.clear()
	return true

func remove_affix() -> int:
	if explicit_affixes.size() <= 0:
		print("No affixes to remove.")
		return -1
	var index : int = randi_range(0, explicit_affixes.size() - 1)
	explicit_affixes.remove_at(index)
	#var a : AffixInstance = explicit_affixes.pick_random()
	#explicit_affixes.erase(a)
	_update_stats()
	print("Affix removed!")
	return index

func reroll_affixes() -> bool:
	clear_explicit_affixes()
	for i in range(min(affix_limit, 3)):
		add_affix()
	_update_stats()
	return true
