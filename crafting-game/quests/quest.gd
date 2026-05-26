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
@export var duration : float = 1.0 # Duration of quest once arrived?
@export var resource_rewards : Dictionary[String, int] = {}
@export var item_rewards : Array[SlotData] = []
@export var party_members : Array[HeroData] = []
@export var party_size : int = 3

# TODO: Duration should be affected by cumulative speed mods on members
# TODO: Figure out what should contribute to rewards

func set_location(l: String) -> void:
	location = l
	# TODO: Update function. Maybe add enum for locations or something

func set_duration() -> void:
	duration = 10.00
	# TODO: Update duration with formula based on difficulty and other factors

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
	d["duration"] = duration
	# TODO: finish
	return d

func from_dict(d: Dictionary) -> void:
	difficulty = d["difficulty"]
	# TODO: Finish
#endregion
