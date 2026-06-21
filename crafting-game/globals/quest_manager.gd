## Global - QuestManager
extends Node

signal quest_started(q: Quest)
signal quest_completed(q: Quest)

const QUEST_LIMIT : int = 4

var available_quest_types : Array[Quest.QuestType] = [Quest.QuestType.BUILD]
var quests : Array[Quest] = []

func _ready() -> void:
	_add_initial_quests()
	#TimeManager.tick.connect(_on_time_tick)

#func _on_time_tick(_h: int, _m: int) -> void:
	#_advance_quests()

#func _advance_quests() -> void:
	#for q: Quest in quests:
		#q.advance()

func _add_initial_quests() -> void:
	var q: QuestHunt = generate_hunt_quest(Constants.Locations.FARMLANDS)
	q.add_resource_reward("gold", 137)
	q.add_resource_reward("wood", 10)
	q.add_item_reward(ItemFactory.generate_equipment())
	q.add_item_reward(ItemFactory.generate_equipment())
	q.add_item_reward(ItemFactory.generate_equipment())
	q.quest_title = "Hunt Foxes"
	quests.append(q)
	
	var qb : QuestBuild = generate_build_quest(Constants.Buildings.TAVERN, 1)
	qb.add_resource_reward("gold", 50)
	qb.add_resource_reward("wood", 20)
	qb.quest_title = "Restore the Tavern"
	quests.append(qb)
	start_quest(qb)

func generate_build_quest(b: Constants.Buildings, l: int = 1) -> QuestBuild:
	var q : QuestBuild = QuestBuild.new()
	q.set_building(b, l)
	return q

func generate_hunt_quest(l: Constants.Locations) -> QuestHunt:
	var q : QuestHunt = QuestHunt.new()
	q.set_location(l) # TODO: Need to generate quest rewards
	return q

# TODO: Is this necessary anymore?
func start_quest(q: Quest) -> void: # TODO: Add timer for travel time / duration / etc
	if q.start():
		quest_started.emit(q)

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

func get_location_quests(loc: Constants.Locations) -> Array[Quest]:
	return quests.filter(func(q: Quest): return q is PartyQuest and q.location == loc)

func get_active_quests() -> Array[Quest]:
	return quests.filter(
		func(q: Quest): 
			return q.state in [
				Quest.QuestState.TRAVELING,
				Quest.QuestState.IN_PROGRESS,
				Quest.QuestState.RETURNING
				]
			)
