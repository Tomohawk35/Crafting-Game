extends Control
class_name ItemSlotUI

var slot_data : SlotData

@onready var sprite_2d: Sprite2D = $PanelContainer/MarginContainer/Sprite2D
@onready var label: Label = $PanelContainer/MarginContainer/Label

func set_slot_data(data: SlotData) -> void:
	slot_data = data

func update() -> void:
	if slot_data:
		sprite_2d.texture = slot_data.item.icon
		label.text = str(slot_data.quantity)
	else:
		sprite_2d.texture = null
		label.text = ""
