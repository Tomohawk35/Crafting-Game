extends PathFollow2D
class_name MapCaravan

# can update progress and progress_ratio
# probably use progress

# questing_speed and travel_speed

var quest : Quest

func _ready() -> void:
	if !quest:
		print("Caravan does not have a valid quest.")
		return # TODO: Queue free here
	_update_position()

func _process(_delta: float) -> void:
	if !quest:
		return # TODO: Queue free
	_update_position()

func _update_position() -> void:
	match quest.state:
		Quest.QuestState.TRAVELING:
			progress = quest.route_position
			pass # TODO: Animate the caravan and update its position
		Quest.QuestState.IN_PROGRESS:
			progress_ratio = 1.0 # TODO: Idle animation
		Quest.QuestState.RETURNING:
			progress = quest.route_position
		_:
			pass
