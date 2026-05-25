## GLOBAL - GameManager
extends Node

signal resource_changed(resource: String)

const INVENTORY_CAPACITY : int = 99

var resources : Dictionary[String, int] = {
	"gold" : 10000,
	"wood" : 10000,
	"stone" : 10000,
} # TODO: update to a resource instead for reusability 

var inventory : Array[SlotData] = []

# BUILDINGS
var tavern : BuildingData 

# LOCATIONS 
var locations : Dictionary[String, LocationData] = {}



func _ready() -> void: # TODO: Remove and change to new game or load game functions
	tavern = BuildingData.new()
	tavern.building_name = "tavern"
	tavern.get_data()
	new_location_data()
	add_initial_quests()

func new_location_data() -> void:
	locations = {}
	for loc in GameDB.LOCATIONS.keys():
		var l : LocationData = LocationData.new()
		l.location_name = loc
		l.description = GameDB.LOCATIONS[loc]
		locations[loc] = l

func add_initial_quests() -> void:
	var q: Quest = Quest.new()
	q.add_resource_reward("gold", 50)
	q.add_resource_reward("wood", 10)
	q.quest_name = "Hunt Foxes"
	q.quest_description = "Hunt down the foxes attacking the farm's chickens."
	#q.ty = Quest.QuestType.HUNT
	locations["outer farmlands"].quests.append(q)

func add_resources(r: String, v: int) -> void:
	resources[r] += v
	resource_changed.emit(r)

func has_resources(r: String, v: int) -> bool:
	return resources[r] >= v

func remove_resources(r: String, v: int) -> bool:
	if has_resources(r, v):
		resources[r] -= v
		resource_changed.emit(r)
		return true
	else:
		return false

#region INVENTORY
func add_item(i: Item, q: int = 1) -> bool:
	if i.stackable == false:
		if inventory.size() < INVENTORY_CAPACITY:
			var s : SlotData = SlotData.new()
			s.item = i
			inventory.append(s)
			return true
		else:
			return false
	
	for s : SlotData in inventory:
		if s.item == i and s.can_add(q):
			s.quantity += q
			return true
		else:
			continue
	
	if inventory.size() >= INVENTORY_CAPACITY:
		return false
	else:
		var s : SlotData = SlotData.new()
		s.item = i
		inventory.append(s)
		return true
		# TODO: Need to figure out how to handle when a quest has multiple item rewards
		# either replicate inventory and try to add or force player to add one at a time
#endregion
