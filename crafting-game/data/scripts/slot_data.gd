extends Resource
class_name SlotData

const SLOT_CAPACITY : int = 99

@export var item : Item
@export var quantity : int = 1

func can_add(q: int) -> bool:
	return (quantity + q) <= SLOT_CAPACITY

func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["quantity"] = quantity
	if item is Equipment:
		d["type"] = "equipment"
		d["item"] = item.to_dict()
	else:
		#d["type"] = "item"
		#d["item"] = item.resource_path
		pass
	return d

func from_dict(d: Dictionary) -> void:
	quantity = d["quantity"]
	match d["type"]:
		"equipment":
			item = Equipment.new()
			item.from_dict(d["item"])
		"item":
			#item = load(d["item"])
			pass
