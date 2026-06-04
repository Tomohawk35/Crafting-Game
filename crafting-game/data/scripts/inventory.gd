extends Resource
class_name Inventory

var slot_capacity : int = 21

var slots : Array[SlotData] = []



#region SORT-RELATED FUNCTIONS
func _exchange(data : Array[SlotData], m : int, n : int) -> void:
	var temp : SlotData = data[m]
	data[m] = data[n]
	data[n] = temp

#func _generate_intervals(n: int) -> Array[int]:
	#var arr : Array[int] = []
	#if n < 2:
		#return arr
	#var t : int = max(1, log
#
#func _shell_sort_better(data : Array[SlotData]) -> void:
	#pass

func _sort_by_name(a : SlotData, b : SlotData) -> bool:
	return a.item.item_name.naturalnocasecmp_to(b.item.item_name) < 0

func _sort_by_name_and_quantity(a : SlotData, b : SlotData) -> bool:
	if a.item.item_name == b.item.item_name:
		return a.quantity > b.quantity
	return a.item.item_name.naturalnocasecmp_to(b.item.item_name) < 0 

#func _sort_by_rarity(a : SlotData, b : SlotData) -> bool:
	#return a.item.rarity > b.item.rarity
#endregion

func add(item: SlotData) -> bool: # FIXME: Should we just add as much as we can or check if we can add full stack?
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
				break
		return true

func remove(item: SlotData) -> bool:
	var temp : Array[SlotData] = []
	var count : int = 0
	
	for slot in slots:
		if slot.item == item.item:
			temp.append(slot)
			count += slot.quantity
			if count >= item.quantity:
				break # TODO: add items
	
	if count < item.quantity:
		return false
	
	var q : int
	for slot in temp:
		q = min(item.quantity, slot.quantity)
		slot.quantity -= q
		item.quantity -= q
		if item.quantity <= 0:
			break
	
	for slot in temp:
		if slot.quantity <= 0:
			slots.erase(slot)
	return true

func sort() -> void:
	slots.sort_custom(_sort_by_name_and_quantity)
