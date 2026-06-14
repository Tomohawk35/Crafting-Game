extends Node2D
class_name UpgradeableBuilding


@export var building_name : Constants.Buildings = Constants.Buildings.TAVERN

var data : BuildingData
var is_clickable : bool = false

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var clickable_area: ClickableAreaComponent = $ClickableArea

func _ready() -> void:
	#if !building_name:
		#queue_free()
	data = GameManager.buildings[building_name]
	data.leveled_up.connect(_on_building_level_up)
	clickable_area.clicked.connect(_on_clicked)
	_update_sprite()
	label.text = data.building_name

func _on_building_level_up() -> void:
	_update_sprite()

func _on_clicked() -> void:
	#EventBus.tavern_clicked.emit()
	EventBus.building_clicked.emit(building_name)

func _update_sprite() -> void:
	sprite_2d.texture = data.get_current_sprite()
