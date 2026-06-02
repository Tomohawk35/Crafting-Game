extends Node
class_name TravelRoutes

const MAP_CARAVAN : PackedScene = preload("uid://b2fjby8apri63")

@export var routes : Dictionary[String, Path2D] = {}

func _ready() -> void:
	QuestManager.quest_started.connect(_on_quest_started)

func _spawn_caravan(q: Quest) -> void:
	q.travel_distance = routes[q.location].curve.get_baked_length()
	var caravan : MapCaravan = MAP_CARAVAN.instantiate()
	caravan.quest = q
	routes[q.location].add_child(caravan)

func _on_quest_started(q: Quest) -> void:
	if !routes.has(q.location):
		print("Travel route to %s not open." % q.location)
		return
	_spawn_caravan(q)

func _load_caravans() -> void:
	for q : Quest in QuestManager.get_active_quests():
		_spawn_caravan(q)
