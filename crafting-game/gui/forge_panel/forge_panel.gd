extends Control
class_name ForgePanel

const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")
const BUTTON_INITIAL_X_POSITION : float = -300.0
const INVENTORY_PANEL_INITIAL_POSITION : Vector2 = Vector2(300.0, 0)
const TWEEN_DURATION : float = 0.4


var item_data : SlotData

@onready var item_panel: PanelContainer = %ItemPanel
@onready var item_name_label: Label = %ItemNameLabel
@onready var implicit_affix_label_container: VBoxContainer = %ImplicitAffixLabelContainer
@onready var explicit_affix_label_container: VBoxContainer = %ExplicitAffixLabelContainer
@onready var implicit_affix_separator: HSeparator = %ImplicitAffixSeparator
@onready var explicit_affix_separator: HSeparator = %ExplicitAffixSeparator
@onready var inventory_panel: PanelContainer = %InventoryPanel
@onready var button_container: VBoxContainer = %ButtonContainer
@onready var reforge_button: PanelContainer = %ReforgeButton
@onready var add_button: PanelContainer = %AddButton
@onready var remove_button: PanelContainer = %RemoveButton
@onready var inventory_container: GridContainer = %InventoryContainer
@onready var forge_slot: ItemSlotUI = %ForgeSlot

func _ready() -> void:
	hide()
	reforge_button.gui_input.connect(_on_reforge_button_pressed) # TODO: Does it cost currency to perform this?
	add_button.gui_input.connect(_on_add_button_pressed)
	remove_button.gui_input.connect(_on_remove_button_pressed)
	
	#item_data = SlotData.new()
	#item_data.item = ItemFactory.generate_equipment()
	
	_setup_initial_positions()
	#open()

func _setup_initial_positions() -> void:
	button_container.position.x = BUTTON_INITIAL_X_POSITION
	inventory_panel.position = INVENTORY_PANEL_INITIAL_POSITION
	#item_panel.modulate.a = 0

func _add_affix_label(text: String, is_implicit : bool = false) -> void:
	var l : Label = Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_WORD
	if is_implicit:
		implicit_affix_label_container.add_child(l)
	else:
		explicit_affix_label_container.add_child(l)

func _error_tween(c: Control) -> Tween:
	var initial_color : Color = c.modulate
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(c, "modulate", Color.RED, 0.20)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(c, "modulate", initial_color, 0.20) # BUG: When button is spammed, it gets stuck on red
	return tween

func _fade_out_tween(c: Control) -> Tween:
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(c, "modulate:a", 0.0, 0.25)
	return tween

func _on_add_button_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("select") and item_data:
		if item_data.item.add_affix():
			_add_affix_label(item_data.item.explicit_affixes[-1].affix_data.description)
		else:
			_error_tween(add_button)

func _on_reforge_button_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("select") and item_data:
		if item_data.item.reroll_affixes(): # TODO: Add functionality
			_update_affix_labels()

func _on_remove_button_pressed(event: InputEvent) -> void: # TODO: ADD CLICK SOUND EFFECT
	if event.is_action_pressed("select") and item_data:
		var index : int = item_data.item.remove_affix()
		if index == -1: 
			_error_tween(remove_button)
		else:
			var l : Label = explicit_affix_label_container.get_children()[index]
			var tween = _fade_out_tween(l)
			tween.finished.connect(func(): l.queue_free())

func _on_slot_pressed(data : SlotData) -> void:
	if !data or data.item is not Equipment:
		return
	item_data = data
	_update_affix_labels()

func _update_affix_labels() -> void:
	for child in implicit_affix_label_container.get_children():
		child.queue_free()
	for child in explicit_affix_label_container.get_children():
		child.queue_free()
	
	if !item_data:
		implicit_affix_label_container.hide()
		implicit_affix_separator.hide()
		explicit_affix_label_container.hide()
		explicit_affix_separator.hide()
		return
	
	item_name_label.text = item_data.item.item_name
	forge_slot.set_slot_data(item_data)
	#var l : Label
	if item_data.item.implicit_affixes.size() > 0:
		implicit_affix_label_container.show()
		implicit_affix_separator.show()
		for affix in item_data.item.implicit_affixes:
			_add_affix_label(affix.affix_data.description, true)
	else:
		implicit_affix_label_container.hide()
		implicit_affix_separator.hide()
	
	if item_data.item.explicit_affixes.size() > 0:
		explicit_affix_label_container.show()
		explicit_affix_separator.show()
		for affix in item_data.item.explicit_affixes:
			_add_affix_label(affix.affix_data.description)
	else:
		explicit_affix_label_container.hide()
		explicit_affix_separator.hide()

func _update_inventory_display() -> void: # TODO: Disable or hide non-equipment items in inventory
	for child in inventory_container.get_children():
		child.queue_free()
	var slot_ui : ItemSlotUI
	for slot in GameManager.inventory.slots:
		slot_ui = ITEM_SLOT_UI.instantiate()
		slot_ui.set_slot_data(slot)
		inventory_container.add_child(slot_ui)
		slot_ui.pressed.connect(_on_slot_pressed)

func open() -> void: # TODO: Add cascading movement of buttons when Godot 4.7 is released
	_update_inventory_display()
	_update_affix_labels()
	show()
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(inventory_panel, "position", Vector2.ZERO, TWEEN_DURATION)
	tween.parallel().tween_property(button_container, "position", Vector2.ZERO, TWEEN_DURATION)
	#tween.parallel().tween_property(item_panel, "modulate:a", 255.0, TWEEN_DURATION)

func close() -> void:
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(inventory_panel, "position", INVENTORY_PANEL_INITIAL_POSITION, TWEEN_DURATION)
	tween.parallel().tween_property(button_container, "position", Vector2(BUTTON_INITIAL_X_POSITION, 0), TWEEN_DURATION)
	#tween.parallel().tween_property(item_panel, "modulate:a", 0.0, TWEEN_DURATION)
	tween.tween_callback(func(): hide())
