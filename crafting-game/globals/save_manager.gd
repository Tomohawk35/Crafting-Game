## GLOBAL SaveManager
extends Node

const SAVE_LOCATION : String = "user://save_file.json"
const ENCRYPTION_KEY : String = "564683sd2"

var contents_to_save : Dictionary = {}

func _save() -> void:
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	#var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.WRITE, ENCRYPTION_KEY)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load() -> void:
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		#var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.READ, ENCRYPTION_KEY)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.progress_bar_value = save_data.progress_bar_value
