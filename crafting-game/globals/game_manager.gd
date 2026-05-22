## GLOBAL - GameManager
extends Node

var gold : int = 0

# BUILDINGS
var tavern : BuildingData 

# ADVENTURERS
var recruitable_heroes : Array[HeroData] = [] # TODO: Make wrapper to include recruit cost in case of randomization in cost
var hero_roster : Array[HeroData] = []

# QUESTS


func _ready() -> void:
	tavern = BuildingData.new()
	tavern.building_name = "tavern"
	tavern.get_data()
