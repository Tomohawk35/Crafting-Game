extends Node
class_name Main

const WORLD_MAP : PackedScene = preload("uid://w7yq4ms3djg4")
const VILLAGE : PackedScene = preload("uid://cfpkas3oyludr")

@export var world_root: Node2D

var in_village : bool = false
var village_scene : Node2D
var world_scene : Node2D

func _ready() -> void:
	_load_world_scene()
	EventBus.switch_view.connect(_on_switch_view)

func _load_village_scene() -> void:
	if world_scene:
		world_scene.queue_free()
	village_scene = VILLAGE.instantiate()
	world_root.add_child(village_scene)
	in_village = true

func _load_world_scene() -> void:
	if village_scene:
		village_scene.queue_free()
	world_scene = WORLD_MAP.instantiate()
	world_root.add_child(world_scene)
	in_village = false

func _on_switch_view() -> void:
	if in_village:
		_load_world_scene()
	else:
		_load_village_scene()
