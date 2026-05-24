## Global - HeroManager
extends Node



var hero_roster : Array[HeroData] = []

func get_available_heroes() -> Array[HeroData]:
	return hero_roster.filter(func(h: HeroData): return !h.on_quest)
