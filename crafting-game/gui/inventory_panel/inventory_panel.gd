extends PanelContainer
class_name InventoryPanel

signal slot_pressed(data : SlotData)

const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")

@onready var inventory_container: GridContainer = %InventoryContainer
@onready var sort_button: Button = %SortButton

func _ready() -> void:
	sort_button.pressed.connect(_on_sort_button_pressed)

func _on_slot_pressed(data : SlotData) -> void:
	if !data or data.item is not Equipment:
		return
	slot_pressed.emit(data)

func _on_sort_button_pressed() -> void:
	GameManager.inventory.sort()
	update_inventory_display()

func update_inventory_display() -> void: # TODO: Disable or hide non-equipment items in inventory
	for child in inventory_container.get_children():
		child.queue_free()
	var slot_ui : ItemSlotUI
	for slot in GameManager.inventory.slots:
		slot_ui = ITEM_SLOT_UI.instantiate()
		slot_ui.set_slot_data(slot)
		inventory_container.add_child(slot_ui)
		slot_ui.pressed.connect(_on_slot_pressed)
