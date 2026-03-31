extends Control

var generator : ItemGenerator
var item : EquipmentInstance

@onready var equipment_tooltip: EquipmentTooltip = $EquipmentTooltip
@onready var generate_button: Button = $GenerateButton
@onready var add_button: Button = $AddButton

func _ready() -> void:
	generate_button.pressed.connect(_on_generate_button_pressed)
	add_button.pressed.connect(_on_add_button_pressed)

func _on_generate_button_pressed() -> void:
	if item:
		item.stats_updated.disconnect(_update_tooltip)
	item = ItemGenerator.generate_equipment()
	_update_tooltip()
	item.stats_updated.connect(_update_tooltip)

func _update_tooltip() -> void:
	if item == null:
		return
	equipment_tooltip.set_item(item)

func _on_add_button_pressed() -> void:
	item.add_affix()
