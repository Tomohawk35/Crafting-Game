extends Resource
class_name SlotData

const SLOT_CAPACITY : int = 99

@export var item : Item
@export var quantity : int = 1

func can_add(q: int) -> bool:
	return (quantity + q) <= SLOT_CAPACITY
