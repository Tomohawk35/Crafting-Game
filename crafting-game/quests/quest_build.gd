extends Quest
class_name QuestBuild

var target_building : Constants.Buildings
var target_building_level : int

func _check_level() -> bool:
	return GameManager.buildings[target_building].level >= target_building_level

func start() -> bool:
	if !target_building:
		push_error("No building set for quest")
		return false
	if !target_building_level:
		push_error("No building level set for quest")
		return false
	
	if _check_level():
		complete()
		return true
	else:
		GameManager.buildings[target_building].leveled_up.connect(_check_level)
		return true

func advance() -> void:
	pass

func complete() -> void:
	state = QuestState.COMPLETE
	GameManager.buildings[target_building].leveled_up.disconnect(_check_level)

func to_dict() -> Dictionary:
	var d : Dictionary = {}
	return d

func from_dict(d: Dictionary) -> void:
	pass
