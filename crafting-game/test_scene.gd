extends Control

var generator : ItemGenerator
var item : ItemInstance

@onready var item_tooltip: ItemTooltip = $ItemTooltip
@onready var generate_button: Button = $GenerateButton

func _ready() -> void:
	generate_button.pressed.connect(_on_generate_button_pressed)

func _on_generate_button_pressed() -> void:
	item = ItemGenerator.generate_item()
	item_tooltip.set_item(item)
