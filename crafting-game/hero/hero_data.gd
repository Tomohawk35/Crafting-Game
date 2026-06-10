extends Resource
class_name HeroData

signal stats_updated

const HERO_NAMES : Array[String] = ["Conrad", "Ivor", "Lothar"]
const HERO_TITLES : Array[String] = ["the Brave", "the Cursed Knight", "the Timid"]

const BASE_STAT_RANGE : Array[int] = [5, 15]
const STAT_GROWTH : float = 1.0
const STAT_RARITY_SCALE : float = 0.25

@export var hero_name : String
@export var hero_title : String # Title could give some bonus to stats
@export var hero_job : HeroJob # dictates Growth rate for stats and bonuses for certain quests
@export var rarity : Constants.Rarity # Affect base stats and stat growth
@export var level : int = 1 # Should affect base stats

@export var equipment : Array[SlotData] = [] # TODO: update to slotdata

@export_category("Stats")
@export var base_stats : StatsTable
@export var current_level_stats : StatsTable
@export var total_equipment_stats : StatsTable
@export var total_stats : StatsTable

@export var on_quest : bool = false

# TODO: Add the following
#Rarity / Quantity Multiplier - affects quest rewards
#Exp Gain Multiplier
# Equipment slots

func _init() -> void:
	for i in Constants.EquipmentType.size():
		equipment.append(SlotData.new())

func _get_stat_growth(growth_rate: float, level_change: int = 1) -> float:
	return growth_rate * level_change + rarity * STAT_RARITY_SCALE * level_change

func _get_stats_from_equipment(e: Equipment) -> void:
	if e == null:
		return
	for stat in e.total_stats.stats.keys():
		total_equipment_stats.stats[stat] += e.total_stats.stats[stat]

func get_total_stats() -> void:
	total_equipment_stats = StatsTable.new()
	total_stats = StatsTable.new()
	for e in equipment:
		if e and e.item and e.item is Equipment:
			_get_stats_from_equipment(e.item)
	total_stats.stats["strength"] = (current_level_stats.stats["strength"] + total_equipment_stats.stats["strength"]) * (1 + total_equipment_stats.stats["strength_pct"] / 100)
	total_stats.stats["dexterity"] = (current_level_stats.stats["dexterity"] + total_equipment_stats.stats["dexterity"]) * (1 + total_equipment_stats.stats["dexterity_pct"] / 100)
	total_stats.stats["intelligence"] = (current_level_stats.stats["intelligence"] + total_equipment_stats.stats["intelligence"]) * (1 + total_equipment_stats.stats["intelligence_pct"] / 100)
	total_stats.stats["charisma"] = (current_level_stats.stats["charisma"] + total_equipment_stats.stats["charisma"]) * (1 + total_equipment_stats.stats["charisma_pct"] / 100)
	stats_updated.emit()

func set_base_stats() -> void:
	base_stats = StatsTable.new()
	base_stats.stats["strength"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["dexterity"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["intelligence"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["charisma"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	# TODO: adjust to make base stats generally stronger for higher rarity instead of just adding rarity?

func get_initial_stats() -> void:
	current_level_stats = StatsTable.new()
	current_level_stats.stats["strength"] = base_stats.stats["strength"] + _get_stat_growth(hero_job.strength_growth_rate, level - 1)
	current_level_stats.stats["dexterity"] = base_stats.stats["dexterity"] + _get_stat_growth(hero_job.dexterity_growth_rate, level - 1)
	current_level_stats.stats["intelligence"] = base_stats.stats["intelligence"] + _get_stat_growth(hero_job.intelligence_growth_rate, level - 1)
	current_level_stats.stats["charisma"] = base_stats.stats["charisma"] + _get_stat_growth(hero_job.charisma_growth_rate, level - 1)
	get_total_stats()

func level_up() -> void:
	level += 1
	current_level_stats.stats["strength"] += _get_stat_growth(hero_job.strength_growth_rate)
	current_level_stats.stats["dexterity"] += _get_stat_growth(hero_job.dexterity_growth_rate)
	current_level_stats.stats["intelligence"] += _get_stat_growth(hero_job.intelligence_growth_rate)
	current_level_stats.stats["charisma"] += _get_stat_growth(hero_job.charisma_growth_rate)
	get_total_stats()

func equip_item(e: SlotData) -> SlotData: # TODO: add remaining equipment slots # HACK: Clean up some way?
	var temp : SlotData
	if equipment[e.item.equipment_type]:
		temp = unequip_item(e.item.equipment_type)
	else:
		temp = SlotData.new()
	equipment[e.item.equipment_type] = e
	get_total_stats()
	equipment[e.item.equipment_type].item.stats_updated.connect(get_total_stats)
	return temp

func unequip_item(slot: Constants.EquipmentType) -> SlotData:
	var temp : SlotData = equipment[slot]
	if temp.item:
		temp.item.stats_updated.disconnect(get_total_stats)
	equipment[slot] = SlotData.new()
	get_total_stats()
	return temp

func get_formatted_name() -> String:
	return hero_name + ", " + hero_title
