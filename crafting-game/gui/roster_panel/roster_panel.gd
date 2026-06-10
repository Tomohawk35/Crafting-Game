extends Control
class_name RosterPanel

const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")
const PANEL_LABEL : PackedScene = preload("uid://ej4wowvxpjnd")

var selected_hero : HeroData

@onready var roster_container: VBoxContainer = %RosterContainer
@onready var inventory_panel: InventoryPanel = %InventoryPanel
@onready var hero_panel: HeroPanel = %HeroPanel

# TODO: Add indicator for hero status (idle, questing, etc.)

func _ready() -> void:
	inventory_panel.slot_pressed.connect(_on_inventory_slot_pressed)
	hero_panel.slot_pressed.connect(_on_hero_panel_slot_pressed)

func _load_roster() -> void:
	selected_hero = null
	for child in roster_container.get_children():
		child.queue_free()
	if HeroManager.hero_roster.size() <= 0:
		return
	var b : Button
	for h : HeroData in HeroManager.hero_roster:
		b = Button.new()
		b.text = h.hero_name
		roster_container.add_child(b)
		b.pressed.connect(_on_hero_selected.bind(h))

func _on_hero_selected(h: HeroData) -> void:
	selected_hero = h
	hero_panel.update_panel(selected_hero)

func _on_hero_panel_slot_pressed(slot_type: Constants.EquipmentType) -> void:
	if !selected_hero:
		return
	if selected_hero.on_quest:
		return
	var temp: SlotData = selected_hero.unequip_item(slot_type)
	if temp.item:
		GameManager.inventory.add(temp)
	_update_hero_panel()
	inventory_panel.update_inventory_display()

func _on_inventory_slot_pressed(data: SlotData) -> void:
	# TODO: Equip to hero and replace equipped item in inventory
	if !selected_hero: 
		return
	if selected_hero.on_quest:
		return
	if data.item is Equipment:
		var index : int = GameManager.inventory.slots.find(data)
		var temp : SlotData = selected_hero.equip_item(data)
		if temp.item:
			GameManager.inventory.slots[index] = temp
		else:
			GameManager.inventory.slots.pop_at(index)
		_update_hero_panel()
		inventory_panel.update_inventory_display()

func _update_hero_panel() -> void:
	if !selected_hero: 
		return
	hero_panel.update_panel(selected_hero)
	
func open() -> void:
	show()
	_load_roster()
	if HeroManager.hero_roster.size() > 0:
		selected_hero = HeroManager.hero_roster[0]
	if selected_hero:
		hero_panel.update_panel(selected_hero)
	inventory_panel.update_inventory_display()

func close() -> void:
	hide()
