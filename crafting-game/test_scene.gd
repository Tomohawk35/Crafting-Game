extends Control

var generator : ItemGenerator
var item : Equipment

@onready var equipment_tooltip: EquipmentTooltip = $EquipmentTooltip
@onready var generate_button: Button = $GenerateButton
@onready var add_button: Button = $AddButton

func _ready() -> void:
	generate_button.pressed.connect(_on_generate_button_pressed)
	add_button.pressed.connect(_on_add_button_pressed)

func _on_generate_button_pressed() -> void:
	item = ItemGenerator.generate_equipment()
	equipment_tooltip.set_item(item)

func _on_add_button_pressed() -> void:
	item.add_affix()
