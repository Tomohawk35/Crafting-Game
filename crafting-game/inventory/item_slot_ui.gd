extends Control
class_name ItemSlotUI

const SLOT_TEXTURES : Array[String] = [
	"res://assets/retro_inventory/Inventory_Slot_1.png",
	"res://assets/retro_inventory/Inventory_Slot_2.png",
	"res://assets/retro_inventory/Inventory_Slot_3.png",
	"res://assets/retro_inventory/Inventory_Slot_4.png",
	"res://assets/retro_inventory/Inventory_Slot_5.png",
	"res://assets/retro_inventory/Inventory_Slot_6.png",
	"res://assets/retro_inventory/Inventory_Slot_7.png",
	"res://assets/retro_inventory/Inventory_Slot_8.png",
	"res://assets/retro_inventory/Inventory_Slot_9.png",
	"res://assets/retro_inventory/Inventory_Slot_10.png",
]

@export var is_equipment_slot : bool = false
@export var equipment_type : Constants.EquipmentType = Constants.EquipmentType.WEAPON

var slot_data : SlotData

@onready var item_sprite: Sprite2D = $PanelContainer/MarginContainer/ItemSprite
@onready var label: Label = $PanelContainer/MarginContainer/Label


#func set_slot_background() -> void:
	#if is_equipment_slot == false or slot_data != null:
		##panel_container.texture = load(SLOT_TEXTURES[0])
	#else:
		#panel_container.theme.set_stylebox(Panel) = load(SLOT_TEXTURES[equipment_type + 1])

func set_slot_data(data: SlotData) -> void:
	slot_data = data
	update()

func update() -> void:
	if slot_data:
		item_sprite.texture = slot_data.item.icon
		label.text = str(slot_data.quantity)
	else:
		item_sprite.texture = null
		label.text = ""
