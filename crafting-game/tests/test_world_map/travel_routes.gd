extends Node
class_name TravelRoutes

const MAP_CARAVAN : PackedScene = preload("uid://b2fjby8apri63")

@export var routes : Dictionary[Constants.Locations, Path2D] = {}

func _ready() -> void:
	ExpeditionManager.expedition_started.connect(_on_expedition_started)
	_load_caravans()

func _spawn_caravan(e: Expedition) -> void:
	e.travel_distance = routes[e.location].curve.get_baked_length()
	var caravan : MapCaravan = MAP_CARAVAN.instantiate()
	caravan.set_expedition(e)
	routes[e.location].add_child(caravan)

func _on_expedition_started(e: Expedition) -> void:
	if !routes.has(e.location):
		print("Travel route to %s not open." % Constants.LOCATION_ENUM_STRING[e.location])
		return
	_spawn_caravan(e)

func _load_caravans() -> void:
	for e : Expedition in ExpeditionManager.expeditions:
		_spawn_caravan(e)
