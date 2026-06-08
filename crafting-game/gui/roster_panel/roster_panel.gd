extends Control
class_name RosterPanel

const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")
const PANEL_LABEL : PackedScene = preload("uid://ej4wowvxpjnd")

var selected_hero : HeroData

@onready var roster_container: VBoxContainer = %RosterContainer
@onready var stat_container: VBoxContainer = %StatContainer
@onready var inventory_panel: InventoryPanel = %InventoryPanel
@onready var equipment_container_1: VBoxContainer = %EquipmentContainer1
@onready var equipment_container_2: VBoxContainer = %EquipmentContainer2
@onready var hero_panel: HeroPanel = %HeroPanel

# TODO: Add indicator for hero status (idle, questing, etc.)

func _ready() -> void:
	inventory_panel.slot_pressed.connect(_on_slot_pressed)

func _load_roster() -> void:
	for child in roster_container.get_children():
		child.queue_free()
	var b : Button
	for h : HeroData in HeroManager.hero_roster:
		b = Button.new()
		b.text = h.hero_name
		roster_container.add_child(b)
		b.pressed.connect(_on_hero_selected.bind(h))

func _on_hero_selected(h: HeroData) -> void:
	selected_hero = h
	hero_panel.update_panel(selected_hero)
	# TODO: Update hero and stat panels

func _on_slot_pressed(data: SlotData) -> void:
	# TODO: Equip to hero and replace equipped item in inventory
	pass

func _update_hero_panel() -> void:
	if !selected_hero: 
		return
	
func open() -> void:
	show()
	_load_roster()
	if selected_hero:
		hero_panel.update_panel(selected_hero)
	inventory_panel.update_inventory_display()

func close() -> void:
	hide()
