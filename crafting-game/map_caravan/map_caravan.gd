extends PathFollow2D
class_name MapCaravan

# can update progress and progress_ratio
# probably use progress

# questing_speed and travel_speed

var quest : Quest

func _process(delta: float) -> void:
	if !quest:
		return
	match quest.state:
		Quest.QuestState.TRAVELING:
			pass
		Quest.QuestState.IN_PROGRESS:
			pass
		Quest.QuestState.RETURNING:
			pass
		_:
			pass
