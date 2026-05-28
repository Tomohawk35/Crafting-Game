extends Resource
class_name Quest

enum QuestState { NOT_STARTED, TRAVELING, IN_PROGRESS, RETURNING, COMPLETE }
enum QuestType { HUNT, INVESTIGATE, GATHER, BOSS, DUNGEON }
enum QuestDifficulty { EASY, MEDIUM, HARD, IMPOSSIBLE }


@export var quest_name : String = "A Simple Quest" # TODO: Add functions for getting name and description
@export var quest_description : String = "A new quest for hunting rabbits."
@export var state : QuestState = QuestState.NOT_STARTED
@export var difficulty : int = QuestDifficulty.EASY
@export var location : String = "Nowhere"# Determines travel time
#@export var duration : float = 1.0 # Duration of quest once arrived?
@export var resource_rewards : Dictionary[String, int] = {}
@export var item_rewards : Array[SlotData] = []
@export var party_members : Array[HeroData] = [] # TODO: Change this to a resource "Party" with methods for gathering mod accumulations 
@export var party : Party = Party.new()
@export var party_size : int = 3

@export var travel_distance : float
@export var route_position : float = 0.0

var travel_speed : float = 0.0
var quest_speed : float = 0.0



# TODO: Duration should be affected by cumulative speed mods on members
# TODO: Figure out what should contribute to rewards

func start() -> bool:
	if state != QuestState.NOT_STARTED or party.members.size() <= 0:
		return false
	for member in party.members:
		member.on_quest = true
	state = QuestState.TRAVELING
	travel_speed = (Constants.DEFAULT_TRAVEL_SPEED + party.party_stats["travel_speed_flat"]) * (1.0 + party.party_stats["travel_speed_pct"])
	#quest_speed = (Constants.DEFAULT_QUEST_SPEED + party.party_stats["hunting_flat"]) * (1.0 + party.party_stats["hunting_pct"])
	# TODO: Need dictionary for matching QuestType to related affixes
	return true

func arrived() -> void:
	match state:
		QuestState.TRAVELING:
			route_position = travel_distance
			state = QuestState.IN_PROGRESS
		QuestState.RETURNING:
			route_position = 0.0
			state = QuestState.COMPLETE
		_:
			return

func progress() -> void:
	match state:
		QuestState.TRAVELING:
			route_position += travel_speed
			if route_position >= travel_distance:
				arrived()
		QuestState.IN_PROGRESS:
			pass # TODO: Track time for quest completion
		QuestState.RETURNING:
			route_position -= travel_speed
			if route_position <= travel_distance:
				arrived()
		_:
			return

func set_location(l: String) -> void:
	location = l
	# TODO: Update function. Maybe add enum for locations or something

func set_travel_distance(d: float) -> void:
	travel_distance = d


func add_resource_reward(r: String, v: int) -> void:
	if resource_rewards.has(r):
		resource_rewards[r] += v
	else:
		resource_rewards[r] = v

func add_item_reward(i: Item, q: int = 1) -> void:
	var s : SlotData = SlotData.new()
	s.item = i
	s.quantity = q
	item_rewards.append(s)

func add_party_member(h: HeroData) -> bool:
	if party_members.size() < (difficulty + 1):
		party_members.append(h)
		return true
	else:
		return false

func clear_party() -> void:
	party_members.clear()

#region SAVE / LOAD
func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["difficulty"] = difficulty
	d["location"] = location
	#d["duration"] = duration
	# TODO: finish
	return d

func from_dict(d: Dictionary) -> void:
	difficulty = d["difficulty"]
	# TODO: Finish
#endregion
