## Global - QuestManager
extends Node

signal quest_started(q: Quest)
signal quest_completed(q: Quest)

const QUEST_LIMIT : int = 4

var quests : Array[Quest] = []
#var available_quests : Array[Quest] = []

# NOTE: Quest workflow:
# Select available location > Some quests appear > Select a quest > Assign Party > Start Quest

func _ready() -> void:
	_add_initial_quests()
	TimeManager.tick.connect(_on_time_tick)

func _on_time_tick(_h: int, _m: int) -> void:
	_advance_quests()

func _advance_quests() -> void:
	for q: Quest in quests:
		#if q.state in [Quest.QuestState.TRAVELING, Quest.QuestState.IN_PROGRESS, Quest.QuestState.RETURNING]:
		q.advance()

func _add_initial_quests() -> void:
	var q: Quest = generate_quest("outer farmlands")
	q.add_resource_reward("gold", 50)
	q.add_resource_reward("wood", 10)
	q.add_item_reward(ItemFactory.generate_equipment())
	q.add_item_reward(ItemFactory.generate_equipment())
	q.add_item_reward(ItemFactory.generate_equipment())
	q.quest_name = "Hunt Foxes"
	q.quest_description = "Hunt down the foxes attacking the farm's chickens."
	#q.ty = Quest.QuestType.HUNT
	quests.append(q)

func generate_quest(location_name : String = "Generic") -> Quest:
	var q : Quest = Quest.new()
	# TODO: Setup quest data
	q.set_location(location_name)
	return q

#func generate_new_quests() -> void:
	#available_quests.clear()
	#for i in range(QUEST_LIMIT):
		#var q : Quest = generate_quest()
		#available_quests.append(q)

func start_quest(q: Quest) -> void: # TODO: Add timer for travel time / duration / etc
	if q.start():
		print("Quest has been started.")
		quest_started.emit(q)
		print("Signal has been emitted")
		# TODO: Check for valid party members before starting

func complete_quest(q: Quest) -> void:
	for member in q.party_members:
		member.on_quest = false
	# TODO: Disperse xp or levels to members?
	for res in q.resource_rewards.keys():
		GameManager.add_resources(res, q.resource_rewards[res])
		for s: SlotData in q.item_rewards:
			GameManager.add_item(s.item, s.quantity)
		# TODO: Need better way to make sure all items can be added to inventory
	quests.erase(q)
	quest_completed.emit(q)

func get_location_quests(loc: String) -> Array[Quest]:
	return quests.filter(func(q: Quest): return q.location == loc)

func get_active_quests() -> Array[Quest]:
	return quests.filter(
		func(q: Quest): 
			return q.state in [
				Quest.QuestState.TRAVELING,
				Quest.QuestState.IN_PROGRESS,
				Quest.QuestState.RETURNING
				]
			)
