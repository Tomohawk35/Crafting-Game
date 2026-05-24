## Global - QuestManager
extends Node

signal quest_started(q: Quest)
signal quest_completed(q: Quest)

const QUEST_LIMIT : int = 4

var active_quests : Array[Quest] = []
var available_quests : Array[Quest] = []

# NOTE: Quest workflow:
# Select available location > Some quests appear > Select a quest > Assign Party > Start Quest

func generate_new_quests() -> void:
	available_quests.clear()
	for i in range(QUEST_LIMIT):
		var q : Quest = Quest.new()
		# TODO: Setup quest data
		available_quests.append(q)

func start_quest(q: Quest) -> bool: # TODO: Add timer for travel time / duration / etc
	if q.party_members.size() < 1:
		return false
	for member in q.party_members:
		member.on_quest = true
	active_quests.append(q)
	available_quests.erase(q)
	quest_started.emit(q)
	return true

func complete_quest(q: Quest) -> void:
	for member in q.party_members:
		member.on_quest = false
	# TODO: Disperse xp or levels to members?
	for res in q.resource_rewards.keys():
		GameManager.add_resources(res, q.resource_rewards[res])
		for s: SlotData in q.item_rewards:
			GameManager.add_item(s.item, s.quantity)
		# TODO: Need better way to make sure all items can be added to inventory
	active_quests.erase(q)
	quest_completed.emit(q)
