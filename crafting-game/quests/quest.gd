extends Resource
class_name Quest

@export var location : String # Determines travel time
@export var duration : String # Duration of quest once arrived?
@export var resource_rewards : Dictionary[String, int] = {}
@export var item_rewards : Array[SlotData] = []
