## GLOBAL SaveManager
extends Node

#const BASE_DIR : String = "user://saves"
const BASE_DIR : String = "res://saves"
const ENCRYPTION_KEY : String = "564683sd2"

var contents_to_save : Dictionary = {}

# NOTE: Reference https://www.youtube.com/watch?v=R-rALRlgbe8


func _capture_state() -> Dictionary:
	var state : Dictionary = {
		"version" : 1,
		"data" : {}
	}
	
	for node in get_tree().get_nodes_in_group("persist"):
		if node.has_method("save_to_state"):
			node.save_to_state(state["data"])
	
	return state

func _apply_state(state: Dictionary) -> void:
	var data : Dictionary = state.get("data", {})
	
	for node in get_tree().get_nodes_in_group("persist"):
		if node.has_method("load_from_state"):
			node.load_from_state(data)

func _slot_dir(slot: int) -> String:
	return BASE_DIR + "/slot_%d" % slot

func _slot_path(slot: int) -> String:
	return _slot_dir(slot) + "/" + "save.json"

func _temp_path(slot: int) -> String:
	return _slot_dir(slot) + "/" + "save.tmp"

func save_slot(slot: int) -> void:
	var slot_dir : String = _slot_dir(slot)
	DirAccess.make_dir_recursive_absolute(slot_dir)
	
	var file_path : String = _slot_path(slot)
	var tmp_path : String = _temp_path(slot)
	
	#var data : Dictionary = _capture_state()
	var data : String = JSON.stringify(_capture_state(), "\t")
	
	var file : FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	#var file = FileAccess.open_encrypted_with_pass(BASE_DIR, FileAccess.WRITE, ENCRYPTION_KEY)
	file.store_string(data)
	file.close()
	if DirAccess.rename_absolute(tmp_path, file_path) != Error.OK:
		print("Failed to rename file.")

func load_slot(slot: int) -> void: # TODO: Need to test this function
	var file_path : String = _slot_path(slot)
	
	if not FileAccess.file_exists(file_path):
		print("Error: File does not exist at ", file_path)
		return
	
	#var file = FileAccess.open_encrypted_with_pass(BASE_DIR, FileAccess.READ, ENCRYPTION_KEY)
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Could not open file at ", file_path)
		return
	
	var json_text : String = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(json_text)
	
	if data == null:
		print("Error: Failed to parse JSON text.")
	
	_apply_state(data)


# NOTE: add nodes you want saved to group "persist"
# these nodes implement following functions

#func save_to_state(state: Dictionary) -> void:
	#pass
#
#func load_from_state(state: Dictionary) -> void:
	#pass
