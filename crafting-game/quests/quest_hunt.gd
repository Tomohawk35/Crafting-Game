extends PartyQuest
class_name QuestHunt



func _set_quest_duration() -> void:
	quest_speed = (Constants.DEFAULT_QUEST_SPEED + party.party_stats.stats["hunting_speed_flat"]) * (1.0 + party.party_stats.stats["hunting_speed_pct"])

func get_description() -> String: # TODO: Make dependent on the location
	return "Hunt monsters in the %s" % GameManager.locations[location].location_name

func to_dict() -> Dictionary:
	var d : Dictionary = super()
	return d

func from_dict(d: Dictionary) -> void:
	super(d)
	pass
