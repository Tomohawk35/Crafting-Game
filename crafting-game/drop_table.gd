extends Resource
class_name DropTable

@export var xp_reward : int = 10
@export var gold_reward : int = 10

@export var item_weights : Dictionary[ItemData, int] = {}

func roll_item() -> ItemData:
	if item_weights.is_empty():
		return null
	
	var total : int = 0
	for w in item_weights.values():
		total += w
	
	var roll : int = randi_range(1, total)
	
	for item in item_weights.keys():
		if roll <= item_weights[item]:
			return item
		roll -= item_weights[item]
	
	return null
