extends Resource
class_name HeroData

signal stats_updated

const HERO_NAMES : Array[String] = ["Conrad", "Ivor", "Lothar"]
const HERO_TITLES : Array[String] = ["The Brave", "The Cursed Knight", "The Timid"]

const BASE_STAT_RANGE : Array[int] = [5, 15]
const STAT_GROWTH : float = 1.0
const STAT_RARITY_SCALE : float = 0.25

@export var hero_name : String
@export var hero_title : String # Title could give some bonus to stats
@export var hero_job : HeroJob # dictates Growth rate for stats and bonuses for certain quests
@export var rarity : Constants.Rarity # Affect base stats and stat growth
@export var level : int = 1 # Should affect base stats

@export_category("Base Stats")
@export var base_strength : float
@export var base_dexterity : float
@export var base_intelligence : float
@export var base_charisma : float

@export_category("Current Level Stats")
@export var strength : float
@export var dexterity : float
@export var intelligence : float
@export var charisma : float

@export_category("Equipment")
@export var weapon : Equipment
@export var helmet : Equipment

@export_category("Final Stats")
@export var total_equipment_stats : StatsTable
@export var total_strength : float
@export var total_dexterity : float
@export var total_intelligence : float
@export var total_charisma : float


# TODO: Add the following
#Rarity / Quantity Multiplier - affects quest rewards
#Exp Gain Multiplier
# Equipment slots

func _get_stat_growth(growth_rate: float, level_change: int = 1) -> float:
	return growth_rate * level_change + rarity * STAT_RARITY_SCALE * level_change

func _get_stats_from_equipment(equipment: Equipment) -> void:
	if equipment == null:
		return
	for stat in equipment.total_stats.stats.keys():
		total_equipment_stats.stats[stat] += equipment.total_stats.stats[stat]

func get_total_stats() -> void:
	total_equipment_stats = StatsTable.new()
	_get_stats_from_equipment(weapon)
	_get_stats_from_equipment(helmet)
	total_strength = (strength + total_equipment_stats.stats["strength"]) * (1 + total_equipment_stats.stats["strength_pct"] / 100)
	total_dexterity = (dexterity + total_equipment_stats.stats["dexterity"]) * (1 + total_equipment_stats.stats["dexterity_pct"] / 100)
	total_intelligence = (intelligence + total_equipment_stats.stats["intelligence"]) * (1 + total_equipment_stats.stats["intelligence_pct"] / 100)
	total_charisma = (charisma + total_equipment_stats.stats["charisma"]) * (1 + total_equipment_stats.stats["charisma_pct"] / 100)
	stats_updated.emit()

func set_base_stats() -> void:
	base_strength = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_dexterity = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_intelligence = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_charisma = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity

func get_initial_stats() -> void:
	strength = base_strength + _get_stat_growth(hero_job.strength_growth_rate, level - 1)
	dexterity = base_dexterity + _get_stat_growth(hero_job.dexterity_growth_rate, level - 1)
	intelligence = base_intelligence + _get_stat_growth(hero_job.intelligence_growth_rate, level - 1)
	charisma = base_charisma + _get_stat_growth(hero_job.charisma_growth_rate, level - 1)
	stats_updated.emit()

func level_up() -> void:
	level += 1
	strength += _get_stat_growth(hero_job.strength_growth_rate)
	dexterity += _get_stat_growth(hero_job.dexterity_growth_rate)
	intelligence += _get_stat_growth(hero_job.intelligence_growth_rate)
	charisma += _get_stat_growth(hero_job.charisma_growth_rate)
	get_total_stats()

func equip_item(item: Equipment) -> void:
	match item.equipment_type:
		Constants.EquipmentType.WEAPON:
			if weapon:
				unequip_item(weapon)
			weapon = item
			get_total_stats()
			weapon.stats_updated.connect(get_total_stats)
		Constants.EquipmentType.HELMET:
			if helmet:
				unequip_item(helmet)
			helmet = item
			get_total_stats()
			helmet.stats_updated.connect(get_total_stats)

func unequip_item(item: Equipment) -> void:
	item.stats_updated.disconnect(get_total_stats)
	# TODO: Move item to inventory
