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

#@export_category("Base Stats")
#@export var base_strength : float
#@export var base_dexterity : float
#@export var base_intelligence : float
#@export var base_charisma : float

#@export_category("Current Level Stats")
#@export var strength : float
#@export var dexterity : float
#@export var intelligence : float
#@export var charisma : float

@export_category("Equipment") # WEAPON, BODY_ARMOR, SHIELD, HELMET, RING, AMULET, GLOVES
#@export var weapon : Equipment
#@export var body_armor : Equipment
#@export var shield : Equipment
#@export var helmet : Equipment
#@export var ring : Equipment
#@export var amulet : Equipment
#@export var gloves : Equipment
@export var equipment : Array[Equipment] = []

@export_category("Final Stats")
@export var total_equipment_stats : StatsTable
#@export var total_strength : float
#@export var total_dexterity : float
#@export var total_intelligence : float
#@export var total_charisma : float

@export var base_stats : StatsTable
@export var current_level_stats : StatsTable
@export var total_stats : StatsTable


# TODO: Add the following
#Rarity / Quantity Multiplier - affects quest rewards
#Exp Gain Multiplier
# Equipment slots

func _init() -> void:
	for i in Constants.EquipmentType.size():
		equipment.append(null)

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
		_get_stats_from_equipment(e)
	#_get_stats_from_equipment(weapon)
	#_get_stats_from_equipment(helmet)
	#_get_stats_from_equipment(ring)
	#_get_stats_from_equipment(gloves)
	#_get_stats_from_equipment(amulet)
	#_get_stats_from_equipment(shield)
	#_get_stats_from_equipment(body_armor)
	total_stats.stats["strength"] = (current_level_stats.stats["strength"] + total_equipment_stats.stats["strength"]) * (1 + total_equipment_stats.stats["strength_pct"] / 100)
	total_stats.stats["dexterity"] = (current_level_stats.stats["dexterity"] + total_equipment_stats.stats["dexterity"]) * (1 + total_equipment_stats.stats["dexterity_pct"] / 100)
	total_stats.stats["intelligence"] = (current_level_stats.stats["intelligence"] + total_equipment_stats.stats["intelligence"]) * (1 + total_equipment_stats.stats["intelligence_pct"] / 100)
	total_stats.stats["charisma"] = (current_level_stats.stats["charisma"] + total_equipment_stats.stats["charisma"]) * (1 + total_equipment_stats.stats["charisma_pct"] / 100)
	stats_updated.emit()

func set_base_stats() -> void:
	#base_strength = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	#base_dexterity = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	#base_intelligence = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	#base_charisma = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats = StatsTable.new()
	base_stats.stats["strength"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["dexterity"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["intelligence"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity
	base_stats.stats["charisma"] = randi_range(BASE_STAT_RANGE[0], BASE_STAT_RANGE[1]) + rarity

func get_initial_stats() -> void:
	#strength = base_strength + _get_stat_growth(hero_job.strength_growth_rate, level - 1)
	#dexterity = base_dexterity + _get_stat_growth(hero_job.dexterity_growth_rate, level - 1)
	#intelligence = base_intelligence + _get_stat_growth(hero_job.intelligence_growth_rate, level - 1)
	#charisma = base_charisma + _get_stat_growth(hero_job.charisma_growth_rate, level - 1)
	current_level_stats = StatsTable.new()
	current_level_stats.stats["strength"] = base_stats.stats["strength"] + _get_stat_growth(hero_job.strength_growth_rate, level - 1)
	current_level_stats.stats["dexterity"] = base_stats.stats["dexterity"] + _get_stat_growth(hero_job.dexterity_growth_rate, level - 1)
	current_level_stats.stats["intelligence"] = base_stats.stats["intelligence"] + _get_stat_growth(hero_job.intelligence_growth_rate, level - 1)
	current_level_stats.stats["charisma"] = base_stats.stats["charisma"] + _get_stat_growth(hero_job.charisma_growth_rate, level - 1)
	get_total_stats()

func level_up() -> void:
	level += 1
	#strength += _get_stat_growth(hero_job.strength_growth_rate)
	#dexterity += _get_stat_growth(hero_job.dexterity_growth_rate)
	#intelligence += _get_stat_growth(hero_job.intelligence_growth_rate)
	#charisma += _get_stat_growth(hero_job.charisma_growth_rate)
	current_level_stats.stats["strength"] += _get_stat_growth(hero_job.strength_growth_rate)
	current_level_stats.stats["dexterity"] += _get_stat_growth(hero_job.dexterity_growth_rate)
	current_level_stats.stats["intelligence"] += _get_stat_growth(hero_job.intelligence_growth_rate)
	current_level_stats.stats["charisma"] += _get_stat_growth(hero_job.charisma_growth_rate)
	get_total_stats()

func equip_item(e: Equipment) -> void: # TODO: add remaining equipment slots # HACK: Clean up some way?
	if equipment[e.equipment_type]:
		unequip_item(equipment[e.equipment_type])
	equipment[e.equipment_type] = e
	get_total_stats()
	equipment[e.equipment_type].stats_updated.connect(get_total_stats)
	
	#match item.equipment_type: # WEAPON, BODY_ARMOR, SHIELD, HELMET, RING, AMULET, GLOVES
		#Constants.EquipmentType.WEAPON:
			#if weapon:
				#unequip_item(weapon)
			#weapon = item
			#get_total_stats()
			#weapon.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.BODY_ARMOR:
			#if body_armor:
				#unequip_item(body_armor)
			#body_armor = item
			#get_total_stats()
			#body_armor.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.SHIELD:
			#if shield:
				#unequip_item(shield)
			#shield = item
			#get_total_stats()
			#shield.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.HELMET:
			#if helmet:
				#unequip_item(helmet)
			#helmet = item
			#get_total_stats()
			#helmet.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.RING:
			#if ring:
				#unequip_item(ring)
			#ring = item
			#get_total_stats()
			#ring.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.AMULET:
			#if amulet:
				#unequip_item(amulet)
			#amulet = item
			#get_total_stats()
			#amulet.stats_updated.connect(get_total_stats)
		#Constants.EquipmentType.GLOVES:
			#if gloves:
				#unequip_item(gloves)
			#gloves = item
			#get_total_stats()
			#gloves.stats_updated.connect(get_total_stats)

func unequip_item(e: Equipment) -> void:
	e.stats_updated.disconnect(get_total_stats)
	# TODO: Move item to inventory
