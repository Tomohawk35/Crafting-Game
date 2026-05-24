extends Resource
class_name LocationData

# META DATA
@export var location_name : String = "New Location"
@export var description : String = "A new location."

@export var favor : int = 0 # increases with quest completion

@export var available_quests : Array[Quest] = []
@export var current_quest : Quest
