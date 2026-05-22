## GLOBAL - GameManager
extends Node

signal resource_changed(resource: String)

var resources : Dictionary[String, int] = {
	"gold" : 10000,
	"wood" : 10000,
	"stone" : 10000,
}

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
