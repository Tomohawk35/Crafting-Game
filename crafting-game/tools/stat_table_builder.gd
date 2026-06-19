@tool
extends EditorScript

const STATS_TABLE_PATH : String = "uid://bhgy31elxmysk"
const TARGET_DICTIONARY_NAME : String = "stats"

var stat_definitions : Array[String] = [
	"strength",
	"dexterity",
	"intelligence",
	"charisma",
	"travel_speed",
	"hunting_speed",
	"quest_speed",
	"luck"
]

func _generate_dict() -> Dictionary:
	var dict : Dictionary = {}
	stat_definitions.sort()
	for s : String in stat_definitions:
		dict[s] = 0.0
		dict[s + "_flat"] = 0.0
		dict[s + "_pct"] = 0.0
	return dict


func _run() -> void:
	var file : FileAccess = FileAccess.open(STATS_TABLE_PATH, FileAccess.READ)
	
	if not file:
		printerr("Could not load file at: ", STATS_TABLE_PATH)
		return
	
	var script_text : String = file.get_as_text()
	file.close()
	
	var regex : RegEx = RegEx.new()
	regex.compile("var\\s+" + TARGET_DICTIONARY_NAME + "\\s*:\\s*Dictionary\\s*=\\s*\\{[\\s\\S]*?\\}")
	
	# Format the new dictionary as a valid GDScript string representation
	#var new_dict_string : String = "var " + TARGET_DICTIONARY_NAME + ": Dictionary = " + var_to_str(_generate_dict())
	var new_dict_string : String = "var " + TARGET_DICTIONARY_NAME + ": Dictionary = " + JSON.stringify(_generate_dict(), "\t")
	
	# Perform the replacement
	if regex.search(script_text):
		var updated_text : String = regex.sub(script_text, new_dict_string)
		
		# Write the updated script back to the disk
		var write_file : FileAccess = FileAccess.open(STATS_TABLE_PATH, FileAccess.WRITE)
		if write_file:
			write_file.store_string(updated_text)
			write_file.close()
			print("Successfully replaced dictionary in: ", STATS_TABLE_PATH)
			EditorInterface.get_resource_filesystem().scan()
		else:
			printerr("Failed to open file for writing at: ", STATS_TABLE_PATH)
	else:
		printerr("Could not find a dictionary declaration for: ", TARGET_DICTIONARY_NAME)
