extends Node2D
class_name MapLocation

@export var location_name : String = "None" # TODO: CHange to a constant enum?

#var data : LocationData
var is_clickable : bool = false

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	#if location_name != "None":
		#data = GameManager.locations[location_name]
	area_2d.mouse_entered.connect(_on_mouse_entered_area_2d)
	area_2d.mouse_exited.connect(_on_mouse_exited_area_2d)

func _on_mouse_entered_area_2d() -> void:
	is_clickable = true

func _on_mouse_exited_area_2d() -> void:
	is_clickable = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and is_clickable:
		#print(location_name + " clicked")
		EventBus.location_clicked.emit(location_name)
		get_tree().root.set_input_as_handled()
