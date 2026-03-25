extends Resource
class_name RarityTable

@export var rarity_weights : Dictionary[Constants.Rarity, int] = {
	Constants.Rarity.COMMON : 100,
	Constants.Rarity.UNCOMMON : 50, 
	Constants.Rarity.RARE : 20,
	Constants.Rarity.LEGENDARY : 1
}

func roll_rarity(roll_floor : int = 0) -> Constants.Rarity:
	var total_weight : int = 0
	for w in rarity_weights.values():
		total_weight += w
	var roll : int = randi_range(roll_floor, total_weight)
	for r in rarity_weights.keys():
		if roll <= rarity_weights[r]:
			return r
		roll -= rarity_weights[r]
	print("Function roll_rarity could not acquire valid rarity. Defaulting to Common.")
	return Constants.Rarity.COMMON
