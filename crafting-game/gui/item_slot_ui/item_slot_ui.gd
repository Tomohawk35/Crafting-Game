extends Control
class_name ItemSlotUI

signal pressed(s: SlotData)

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
@export var item_sprite: TextureRect
@export var label: Label

var slot_data : SlotData = SlotData.new()
var clickable : bool = false # TODO: DO we still need this?

# TODO: NEED TO ADD DRAG AND DROP FOR ITEM DATA OR CLICK TO MOVE FOR FORGE
# MAYBE JUST EMIT SIGNAL WITH DATA FOR UI CONTROLLER TO GRAB?

# TODO: NEED TO ADD TOOLTIP FOR HOVER

func _gui_input(event: InputEvent) -> void:
	if !slot_data:
		return
	if event.is_action_pressed("select"):
		pressed.emit(slot_data)
		print("slot clicked")

#func set_slot_background() -> void:
	#if is_equipment_slot == false or slot_data != null:
		##panel_container.texture = load(SLOT_TEXTURES[0])
	#else:
		#panel_container.theme.set_stylebox(Panel) = load(SLOT_TEXTURES[equipment_type + 1])

func set_slot_data(data: SlotData) -> void:
	slot_data = data
	update()

func update() -> void:
	if slot_data and slot_data.item:
		item_sprite.texture = slot_data.item.icon
		if slot_data.quantity > 1:
			label.text = str(slot_data.quantity)
			label.show()
		else:
			label.hide()
	else:
		item_sprite.texture = null
		label.text = ""
