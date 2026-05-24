## GLOBAL - GameManager
extends Node

signal resource_changed(resource: String)

const INVENTORY_CAPACITY : int = 99

var resources : Dictionary[String, int] = {
	"gold" : 10000,
	"wood" : 10000,
	"stone" : 10000,
}

var inventory : Array[SlotData] = []

# BUILDINGS
var tavern : BuildingData 

# ADVENTURERS
var hero_roster : Array[HeroData] = []

# QUESTS


func _ready() -> void:
	tavern = BuildingData.new()
	tavern.building_name = "tavern"
	tavern.get_data()

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
