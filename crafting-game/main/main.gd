extends Node

const WORLD_MAP : PackedScene = preload("uid://w7yq4ms3djg4")
const VILLAGE : PackedScene = preload("uid://cfpkas3oyludr")

@export var world: Node2D

var in_village : bool = false

func _ready() -> void:
	EventBus.switch_view.connect(_on_switch_view)

func _on_switch_view() -> void:
	#if in_village
	pass
