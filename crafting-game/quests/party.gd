extends Resource
class_name Party

@export var party_name : String
@export var max_party_size : int = 3
@export var members : Array[HeroData]
@export var party_stats : StatsTable = StatsTable.new()

func _init() -> void:
	members = []
	for i in range(max_party_size):
		members.append(null)

#func set_party(heroes: Array[HeroData]) -> void:
	#party_stats = StatsTable.new()
	#for h: HeroData in heroes:
		#members.append(h)
		#for stat in h.total_stats.stats.keys():
			#party_stats.stats[stat] += h.total_stats.stats[stat]

func validate_party() -> bool:
	if members.size() <= 0:
		print("Party Fault: No party members.")
		return false
	if members.size() > max_party_size:
		print("Party Fault: Too many party members.")
		return false
	for member in members:
		if members.count(member) > 1:
			print("Party Fault: Party contains duplicate party members.")
			return false
	return true

func add_party_member(h: HeroData) -> bool:
	if h.in_party or members.has(h) or members.size() >= max_party_size:
		return false
	
	var index : int = members.find(null)
	if index == -1:
		return false
	else:
		add_member_at_index(h, index)
		return true
	#if index != -1:
		#remove_member_at_index(index)
		#members[index] = h
		#h.in_party = true
	#if index == -1: # TODO: Find first null place
		#members.append(h)
		#h.in_party = true
	#
	#for stat in h.total_stats.stats.keys():
		#party_stats.stats[stat] += h.total_stats.stats[stat]
	#return true

func add_member_at_index(h: HeroData, index: int) -> void:
	remove_member_at_index(index)
	members[index] = h
	h.in_party = true
	for stat in h.total_stats.stats.keys():
		party_stats.stats[stat] += h.total_stats.stats[stat]

func remove_party_member(h: HeroData) -> bool:
	if members.has(h):
		members.erase(h)
		h.in_party = false
		for stat in h.total_stats.stats.keys():
			party_stats.stats[stat] -= h.total_stats.stats[stat]
		return true
	else:
		return false

func remove_member_at_index(index: int) -> void:
	if !members[index]:
		return
	var h : HeroData = members[index]
	for stat in h.total_stats.stats.keys():
		party_stats.stats[stat] -= h.total_stats.stats[stat]
	h.in_party = false
	members[index] = null

func remove_all_members() -> void:
	#for h : HeroData in members:
		#remove_party_member(h)
	for i in range(members.size()):
		remove_member_at_index(i)
