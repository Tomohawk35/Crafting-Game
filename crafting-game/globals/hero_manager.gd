## Global - HeroManager
extends Node



var hero_roster : Array[HeroData] = []

func _ready() -> void: # TODO: Remove after testing
	add_random_hero()
	add_random_hero()
	add_random_hero()

func add_random_hero() -> void:
	var h : HeroData = HeroGenerator.generate_hero()
	hero_roster.append(h)

func get_available_heroes() -> Array[HeroData]:
	return hero_roster.filter(func(h: HeroData): return !h.on_quest)
