@abstract
extends Resource
class_name Quest

enum QuestState { NOT_STARTED, TRAVELING, IN_PROGRESS, RETURNING, COMPLETE }
enum QuestType { BUILD, HUNT, INVESTIGATE, GATHER, BOSS, DUNGEON }
enum QuestDifficulty { EASY, MEDIUM, HARD, IMPOSSIBLE }


@export var quest_title : String = "A Simple Quest" # TODO: Add functions for getting name and description
@export var state : QuestState = QuestState.NOT_STARTED
#@export var difficulty : int = QuestDifficulty.EASY
#@export var location : String = "General"# Determines travel time

## REWARDS
#@export var resource_rewards : Dictionary[String, int] = {}
#@export var item_rewards : Array[SlotData] = []
@export var rewards : Inventory = Inventory.new()

# TODO: Duration should be affected by cumulative speed mods on members
# TODO: Figure out what should contribute to rewards

@abstract
func get_description() -> String

@abstract
func start() -> bool

@abstract
func advance() -> void

func add_resource_reward(r: String, v: int) -> void:
	#if resource_rewards.has(r):
		#resource_rewards[r] += v
	#else:
		#resource_rewards[r] = v
	if GameDB.CURRENCY.has(r):
		var s : SlotData = SlotData.new()
		s.item = GameDB.CURRENCY[r]
		s.quantity = v
		rewards.add(s)
	

func add_item_reward(i: Item, q: int = 1) -> void:
	var s : SlotData = SlotData.new()
	s.item = i
	s.quantity = q
	#item_rewards.append(s)
	rewards.add(s)

#func add_party_member(h: HeroData) -> bool:
	#if party_members.size() < (difficulty + 1):
		#party_members.append(h)
		#return true
	#else:
		#return false
#
#func clear_party() -> void:
	#party_members.clear()

##region SAVE / LOAD
func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["quest_title"] = quest_title
	#d["quest_description"] = quest_description
	d["state"] = state
	#d["difficulty"] = difficulty
	d["rewards"] = []
	for slot : SlotData in rewards:
		d["rewards"].append(slot.to_dict)
	return d

func from_dict(d: Dictionary) -> void:
	#difficulty = d["difficulty"]
	# TODO: Finish
	pass
##endregion
