extends Control
class_name ForgePanel

var item_data : Equipment

@onready var implicit_affix_label_container: VBoxContainer = %ImplicitAffixLabelContainer
@onready var explicit_affix_label_container: VBoxContainer = %ExplicitAffixLabelContainer
@onready var implicit_affix_separator: HSeparator = %ImplicitAffixSeparator
@onready var explicit_affix_separator: HSeparator = %ExplicitAffixSeparator
@onready var reforge_button: PanelContainer = $VBoxContainer/ReforgeButton
@onready var add_button: PanelContainer = $VBoxContainer/AddButton
@onready var remove_button: PanelContainer = $VBoxContainer/RemoveButton

func _ready() -> void:
	reforge_button.gui_input.connect(_on_reforge_button_pressed) # TODO: Does it cost currency to perform this?
	add_button.gui_input.connect(_on_add_button_pressed)
	remove_button.gui_input.connect(_on_remove_button_pressed)
	
	item_data = ItemFactory.generate_equipment()
	_update_affix_labels()

func _on_add_button_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("select") and item_data:
		if item_data.add_affix():
			_update_affix_labels()

func _on_reforge_button_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("select") and item_data:
		if item_data.reroll_affixes(): # TODO: Add functionality
			_update_affix_labels()

func _on_remove_button_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("select") and item_data:
		if item_data.remove_affix(): # TODO: Change to return bool so can add shake and red effect
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
	
	var l : Label
	if item_data.implicit_affixes.size() > 0:
		implicit_affix_label_container.show()
		implicit_affix_separator.show()
		for affix in item_data.implicit_affixes:
			l = Label.new()
			l.text = affix.affix_data.description
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			l.autowrap_mode = TextServer.AUTOWRAP_WORD
			implicit_affix_label_container.add_child(l)
	else:
		implicit_affix_label_container.hide()
		implicit_affix_separator.hide()
	
	if item_data.explicit_affixes.size() > 0:
		explicit_affix_label_container.show()
		explicit_affix_separator.show()
		for affix in item_data.explicit_affixes:
			l = Label.new()
			l.text = affix.affix_data.description
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			l.autowrap_mode = TextServer.AUTOWRAP_WORD
			explicit_affix_label_container.add_child(l)
	else:
		explicit_affix_label_container.hide()
		explicit_affix_separator.hide()
