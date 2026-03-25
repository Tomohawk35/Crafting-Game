extends Resource
class_name ItemQualityTable

# TODO: CHANGE THIS TO A CURVE?
@export var quality_weights : Dictionary[Constants.ItemQuality, int] = {
	Constants.ItemQuality.BROKEN : 50,
	Constants.ItemQuality.BATTERED : 60,
	Constants.ItemQuality.WORN : 80,
	Constants.ItemQuality.NORMAL : 100,
	Constants.ItemQuality.STURDY : 40,
	Constants.ItemQuality.EXCEPTIONAL : 10,
	Constants.ItemQuality.IMMACULATE : 1
}

func roll_quality(roll_floor : int = 0) -> Constants.ItemQuality:
	var total_weight : int = 0
	for w in quality_weights.values():
		total_weight += w
	var roll : int = randi_range(roll_floor, total_weight)
	for r in quality_weights.keys():
		if roll <= quality_weights[r]:
			return r
		roll -= quality_weights[r]
	print("Function roll_quality could not acquire valid quality. Defaulting to Worn.")
	return Constants.ItemQuality.WORN
