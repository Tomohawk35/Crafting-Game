extends Node
class_name Utils

static func get_weighted_result(dict: Dictionary, floor_value: int = 0) -> Variant:
	var total_weight : int = 0
	for value in dict.values():
		total_weight += value
	var rand_value : int = randi_range(floor_value, total_weight)
	#print("rand_value = ", str(rand_value))
	for key in dict.keys():
		if rand_value <= dict[key]:
			#print("returned value = ", str(key))
			return key
		rand_value -= dict[key]
	return null

static func load_asset(path: String) -> Resource:
	if OS.has_feature("export"):
		if not path.ends_with(".remap"):
			return load(path)
		
		var __config_file = ConfigFile.new()
		__config_file.load(path)
		
		# Load the remapped file
		var __remapped_file_path = __config_file.get_value("remap", "path")
		__config_file = null
		return load(__remapped_file_path)
	else:
		return load(path)
