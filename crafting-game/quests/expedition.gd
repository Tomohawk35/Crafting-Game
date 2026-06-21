extends Resource
class_name Expedition

enum States { NOT_STARTED, TRAVELING, IN_PROGRESS, RETURNING, COMPLETE }
enum Tasks { HUNT, INVESTIGATE, GATHER, BOSS, DUNGEON }

const DEFAULT_TRAVEL_SPEED : float = 20.0
const DEFAULT_TASK_SPEEDS : Dictionary[Tasks, float] = {
	Tasks.HUNT: 30.0,
	Tasks.INVESTIGATE: 200.0,
	Tasks.GATHER: 30.0,
	Tasks.BOSS: 30.0,
	Tasks.DUNGEON: 200.0,
}

@export var party : Party = Party.new()
@export var location : Constants.Locations
@export var task : Tasks
@export var inventory : Inventory = Inventory.new()
@export var status : States = States.NOT_STARTED
@export var food_reserves : int

@export var travel_distance : float
@export var progress : float = 0.0
@export var task_duration : float

var travel_speed : float = 0.0
var quest_speed : float = 0.0
var food_consumption : int

func _calculate_food_consumption() -> void:
	pass # TODO: Calculate rate. Need affixes for food consumption

func _perform_task() -> void:
	match task:
		Tasks.HUNT:
			# Determine what was hunted
			# Get loot
			# Emit a monster killed signal
			pass
		Tasks.BOSS: # ONE SHOT
			# TODO: Get loot
			# Emit a boss slain signal
			recall()
		Tasks.DUNGEON: # ONE SHOT
			# TODO: Get loot
			# Emit a dungeon completed signal
			recall()
		_:
			pass

func _set_travel_speed() -> void:
	travel_speed = (
		(DEFAULT_TRAVEL_SPEED + party.party_stats.stats["travel_speed_flat"]) \
		* (1.0 + party.party_stats.stats["travel_speed_pct"])
	)

func _set_quest_duration() -> void:
	var flat_value : float
	var multiplier : float
	match task:
		Tasks.HUNT:
			flat_value = party.party_stats.stats["hunting_speed_flat"]
			multiplier = party.party_stats.stats["hunting_speed_pct"]
		_:
			pass
	task_duration = (DEFAULT_TASK_SPEEDS[task] + flat_value) * (1.0 + multiplier)

func set_location(l: Constants.Locations) -> void:
	location = l

func start() -> bool:
	if status != States.NOT_STARTED:
		print("Unable to start quest - Quest already started.")
		return false
	if !party.validate_party():
		return false
	#for member in party.members:
		#member.on_quest = true
	status = States.TRAVELING
	_set_travel_speed()
	_set_quest_duration()
	#travel_speed = (Constants.DEFAULT_TRAVEL_SPEED + party.party_stats.stats["travel_speed_flat"]) * (1.0 + party.party_stats.stats["travel_speed_pct"])
	# TODO: Need dictionary for matching QuestType to related affixes
	return true

func advance() -> void: # TODO: Lower food reserves constantly
	
	match status:
		States.TRAVELING:
			progress += travel_speed
			if progress >= travel_distance:
				progress = 0.0
				status = States.IN_PROGRESS
		States.IN_PROGRESS:
			#progress += 1.0 # TODO: Incorporate questing speed
			#if progress >= quest_duration:
				#status = States.RETURNING
				#progress = travel_distance
			progress += 1.0
			if progress >= task_duration:
				_perform_task()
			pass # Perform Task
		States.RETURNING:
			progress -= travel_speed
			if progress <= 0.0:
				progress = 0.0
				status = States.COMPLETE # TODO: Emit completed signal?
		_:
			return

func recall() -> void:
	progress = travel_distance
	status = States.RETURNING

func to_dict() -> Dictionary:
	var d: Dictionary = {}
	# TODO: Save party
	d["location"] = location
	d["travel_distance"] = travel_distance
	d["progress"] = progress
	d["task_duration"] = task_duration
	d["travel_speed"] = travel_speed
	d["quest_speed"] = quest_speed
	return d

func from_dict(d: Dictionary) -> void:
	# TODO: Load party
	location = d["location"]
	travel_distance = d["travel_distance"]
	progress = d["progress"]
	task_duration = d["task_duration"]
	travel_speed = d["travel_speed"]
	quest_speed = d["quest_speed"]
