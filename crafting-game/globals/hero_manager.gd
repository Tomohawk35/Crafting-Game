## Global - HeroManager
extends Node

signal roster_changed

var hero_roster : Array[HeroData] = []
var parties : Array[Party] = []

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
	return hero_roster.filter(func(h: HeroData): return !h.in_party)

func create_party() -> void:
	var p : Party = Party.new()
	p.party_name = "Party " + str(parties.size() + 1)
	parties.append(p)

func delete_party(p: Party) -> void:
	p.remove_all_members()
	parties.erase(p)
