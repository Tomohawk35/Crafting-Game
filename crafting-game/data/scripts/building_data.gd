extends Resource
class_name BuildingData

signal leveled_up

@export var building_id : String
@export var building_name : String

@export var is_max_level : bool = false
@export var level : int = 0
@export var level_up_resource_cost : Dictionary = {}
@export var sprite : Array[Texture2D] = []



#func _check_at_max_level() -> bool:
	#return level >= GameDB.BUILDINGS[building_name].size()

#func set_building_name(n: String) -> void:
	#building_name = n

func get_current_sprite() -> Texture2D:
	return sprite[clamp(level, 0, sprite.size() - 1)]

func update_data() -> void:
	is_max_level = (level >= GameDB.BUILDINGS[building_id].size())
	if is_max_level:
		level_up_resource_cost = {}
	else:
		level_up_resource_cost = {}
		for key in GameDB.BUILDINGS[building_id][level]["upgrade_resource_costs"].keys():
			level_up_resource_cost[key] = GameDB.BUILDINGS[building_id][level]["upgrade_resource_costs"][key]

func level_up() -> void:
	if is_max_level:
		return
	level += 1
	update_data()
	leveled_up.emit()

func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["building_id"] = building_id
	d["level"] = level
	return d

func from_dict(d: Dictionary) -> void:
	building_id = d["building_id"]
	level = d["level"]
	update_data()
