extends Resource
class_name Inventory

var slot_capacity : int = 21

var slots : Array[SlotData] = []





# add
func add(item: SlotData) -> bool:
	if !item.item.stackable:
		if slots.size() >= slot_capacity:
			return false
		else:
			slots.append(item)
			return true
	else: # ITEM IS STACKABLE
		var temp : Array[SlotData] = []
		var available_space : int = 0
		for slot in slots:
			if slot.item == item.item and slot.quantity < slot.SLOT_CAPACITY:
				temp.append(slot)
				available_space += (slot.SLOT_CAPACITY - slot.quantity)
				if available_space >= item.quantity:
					break # TODO: add items
		
		available_space += (SlotData.SLOT_CAPACITY * (slot_capacity - slots.size()))
		if available_space < item.quantity:
			return false
		
		var q : int
		for slot in temp:
			q = min(slot.SLOT_CAPACITY - slot.quantity, item.quantity)
			slot.quantity += q
			item.quantity -= q
			if item.quantity <= 0:
				return true
		
		for i in range(slot_capacity - slots.size()):
			var s : SlotData = SlotData.new()
			s.item = item.item
			slots.append(s)
			q = min(s.SLOT_CAPACITY - s.quantity, item.quantity)
			s.quantity += q
			item.quantity -= q
			if item.quantity <= 0:
				return true
		return false

# remove
# sort
