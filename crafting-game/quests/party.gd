extends Resource
class_name Party

@export var max_party_size : int = 3
@export var members : Array[HeroData] = []
@export var party_stats : StatsTable

#func set_party(heroes: Array[HeroData]) -> void:
	#party_stats = StatsTable.new()
	#for h: HeroData in heroes:
		#members.append(h)
		#for stat in h.total_stats.stats.keys():
			#party_stats.stats[stat] += h.total_stats.stats[stat]

func add_party_member(h: HeroData) -> bool:
	if h.on_quest or members.has(h) or members.size() >= max_party_size:
		return false
	members.append(h)
	for stat in h.total_stats.stats.keys():
		party_stats.stats[stat] += h.total_stats.stats[stat]
	return true

func remove_party_member(h: HeroData) -> bool:
	if members.has(h):
		members.erase(h)
		for stat in h.total_stats.stats.keys():
			party_stats.stats[stat] -= h.total_stats.stats[stat]
		return true
	else:
		return false
