extends Resource
class_name Party

@export var members : Array[HeroData] = []
@export var party_stats : StatsTable

func set_party(heroes: Array[HeroData]) -> void:
	party_stats = StatsTable.new()
	for h: HeroData in heroes:
		members.append(h)
		for stat in h.total_stats.stats.keys():
			party_stats.stats[stat] += h.total_stats.stats[stat]

func get_travel_speed() -> float:
	return 
