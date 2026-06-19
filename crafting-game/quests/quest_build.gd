extends Quest
class_name QuestBuild

var target_building : Constants.Buildings
var target_building_level : int

func _on_building_level_up() -> void:
	if _check_level():
		complete()

func _check_level() -> bool:
	print("Checking level...")
	return GameManager.buildings[target_building].level >= target_building_level

func get_description() -> String: 
	if target_building_level == 1:
		return "Restore the %s." % GameManager.buildings[target_building].building_name
	else:
		return "Upgrade the %s to level %s." % [GameManager.buildings[target_building].building_name, str(target_building_level)]

func set_building(b: Constants.Buildings, l: int = 1) -> void:
	target_building = b
	target_building_level = l

func start() -> bool:
	if _check_level():
		complete()
		return true
	else:
		GameManager.buildings[target_building].leveled_up.connect(_on_building_level_up)
		state = QuestState.IN_PROGRESS
		return true

func advance() -> void:
	pass

func complete() -> void:
	state = QuestState.COMPLETE
	GameManager.buildings[target_building].leveled_up.disconnect(_on_building_level_up)

func to_dict() -> Dictionary: # TODO: Finish save func
	var d : Dictionary = super()
	return d

func from_dict(d: Dictionary) -> void: # TODO: Finish load func
	super(d)
	pass
