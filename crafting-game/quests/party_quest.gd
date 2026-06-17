@abstract
extends Quest
class_name PartyQuest

@export var party : Party = Party.new()
@export var party_size : int = 3
@export var location : Constants.Locations

@export var travel_distance : float
@export var progress : float = 0.0
@export var quest_duration : float = 10.0

var travel_speed : float = 0.0
var quest_speed : float = 0.0

@abstract
func _set_travel_speed() -> void
	#travel_speed = (Constants.DEFAULT_TRAVEL_SPEED + party.party_stats.stats["travel_speed_flat"]) * (1.0 + party.party_stats.stats["travel_speed_pct"])

@abstract
func _set_quest_duration() -> void

func start() -> bool:
	if state != QuestState.NOT_STARTED:
		print("Unable to start quest - Quest already started.")
		return false
	if !party.validate_party():
		return false
	for member in party.members:
		member.on_quest = true
	state = QuestState.TRAVELING
	_set_travel_speed()
	_set_quest_duration()
	#travel_speed = (Constants.DEFAULT_TRAVEL_SPEED + party.party_stats.stats["travel_speed_flat"]) * (1.0 + party.party_stats.stats["travel_speed_pct"])
	# TODO: Need dictionary for matching QuestType to related affixes
	return true

func advance() -> void:
	match state:
		QuestState.TRAVELING:
			progress += travel_speed
			if progress >= travel_distance:
				progress = 0.0
				state = QuestState.IN_PROGRESS
		QuestState.IN_PROGRESS:
			progress += 1.0 # TODO: Incorporate questing speed
			if progress >= quest_duration:
				state = QuestState.RETURNING
				progress = travel_distance
		QuestState.RETURNING:
			progress -= travel_speed
			if progress <= 0.0:
				progress = 0.0
				state = QuestState.COMPLETE # TODO: Emit completed signal?
		_:
			return
