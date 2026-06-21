## Global - HeroManager
extends Node

signal roster_changed

var hero_roster : Array[HeroData] = []
var expeditions : Array[Party] = []

func _ready() -> void: # TODO: Remove after testing
	add_random_hero()
	add_random_hero()
	add_random_hero()

func add_hero(h: HeroData) -> bool: 
	if !h:
		return false
	hero_roster.append(h)
	return true

func add_random_hero() -> void:
	var h : HeroData = HeroFactory.generate_hero()
	hero_roster.append(h)

func get_available_heroes() -> Array[HeroData]:
	return hero_roster.filter(func(h: HeroData): return !h.on_quest)
