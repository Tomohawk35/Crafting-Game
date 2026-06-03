extends Control
class_name ForgePanel

var item_data : Equipment

@onready var implicit_affix_label_container: VBoxContainer = %ImplicitAffixLabelContainer
@onready var explicit_affix_label_container: VBoxContainer = %ExplicitAffixLabelContainer

func _ready() -> void:
	item_data = ItemFactory.generate_equipment()
	_update_affix_labels()

func _update_affix_labels() -> void:
	for child in implicit_affix_label_container.get_children():
		child.queue_free()
	for child in explicit_affix_label_container.get_children():
		child.queue_free()
	var l : Label
	for affix in item_data.implicit_affixes:
		l = Label.new()
		l.text = affix.affix_data.description
		implicit_affix_label_container.add_child(l)
	for affix in item_data.explicit_affixes:
		l = Label.new()
		l.text = affix.affix_data.description
		explicit_affix_label_container.add_child(l)
