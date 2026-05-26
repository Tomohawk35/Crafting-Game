extends Resource
class_name BuildingData

signal leveled_up

@export var building_name : String
@export var is_max_level : bool = false

@export var level : int = 0
@export var level_up_resource_cost : Dictionary = {}

func _check_at_max_level() -> bool:
	return level >= GameDB.BUILDINGS[building_name].size()

func set_building_name(n: String) -> void:
	building_name = n

func get_data() -> void:
	is_max_level = _check_at_max_level()
	if is_max_level:
		level_up_resource_cost = {}
	else:
		level_up_resource_cost = {}
		for key in GameDB.BUILDINGS[building_name][level]["upgrade_resource_costs"].keys():
			level_up_resource_cost[key] = GameDB.BUILDINGS[building_name][level]["upgrade_resource_costs"][key]

func level_up() -> void:
	if is_max_level:
		return
	level += 1
	get_data()
	leveled_up.emit()

func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["building_name"] = building_name
	d["level"] = level
	return d

func from_dict(d: Dictionary) -> void:
	building_name = d["building_name"]
	level = d["level"]
	get_data()
