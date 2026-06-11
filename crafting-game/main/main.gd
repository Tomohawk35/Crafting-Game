extends Node

@onready var world: Node2D = %World

func _ready() -> void:
	EventBus.view_village.connect(_on_view_village)
	EventBus.view_world_map.connect(_on_view_world_map)
