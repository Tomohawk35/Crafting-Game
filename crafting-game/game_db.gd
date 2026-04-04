extends Node

const ITEM_MODIFIERS_FILE_PATH : String = "res://item_modifiers.json"

var AFFIXES : Array[AffixData] = []
var BASE_ITEMS : Array[Equipment] = []
var HERO_JOBS : Array[HeroJob] = []


func _ready() -> void:
	_load_resources_from_folder("res://resources/affixes/", AFFIXES)
	_load_resources_from_folder("res://resources/base_items/", BASE_ITEMS)
	_load_resources_from_folder("res://resources/hero_jobs/", HERO_JOBS)

func _import_data(path: String) -> Dictionary:
	var file_string : String = FileAccess.get_file_as_string(path)
	var dict : Dictionary = {}
	if file_string == "":
		push_error("GameDB: Could not load file at path: " + path)
	else:
		dict = JSON.parse_string(file_string)
	return dict

func _load_resources_from_folder(path: String, target_array: Array) -> void:
	for file in DirAccess.get_files_at(path):
		target_array.append(Utils.load_asset(path + file))

#func load_db() -> void:
	#var item_modifiers_string : String = FileAccess.get_file_as_string(ITEM_MODIFIERS_FILE_PATH)
	#ITEM_MODIFIERS = JSON.parse_string(item_modifiers_string)

func get_random_affix() -> AffixData:
	return AFFIXES.pick_random()

func get_affixes_by_item_type(item_type: Constants.EquipmentType) -> Array[AffixData]:
	return AFFIXES.filter(func(a: AffixData): return a.equipment_types[item_type])

#func get_item_modifiers_by_item_type(item_type: Constants.ItemType) -> Dictionary:
	#var d : Dictionary = {}
	#for mod in ITEM_MODIFIERS.keys():
		#if ITEM_MODIFIERS[mod]["item_types"].has(item_type):
			#d[mod] = ITEM_MODIFIERS[mod]
	#return d
