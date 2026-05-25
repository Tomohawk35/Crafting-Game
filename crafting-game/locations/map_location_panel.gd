extends Control
class_name MapLocationPanel

const QUEST_INFO_PANEL : PackedScene = preload("uid://d3vkayuk7ieia")

@export var name_label: Label
@export var description_label: Label
@export var favor_value_label: Label
@export var no_quests_available_label: Label
@export var quest_container: VBoxContainer

var data : LocationData

func _clear_quest_list() -> void:
	for child in quest_container.get_children():
		child.queue_free()

func _load_quests() -> void:
	if data == null:
		return
	for q: Quest in data.quests:
		var p: QuestInfoPanel = QUEST_INFO_PANEL.instantiate()
		p.update_panel(q)
		quest_container.add_child(p)

func update_panel(d: LocationData) -> void:
	data = d
	name_label.text = data.location_name.capitalize()
	description_label.text = data.description
	favor_value_label.text = str(data.favor)
	if data.quests.size() == 0:
		no_quests_available_label.show()
		quest_container.hide()
	else:
		no_quests_available_label.hide()
		for q: Quest in data.quests:
			var p: QuestInfoPanel = QUEST_INFO_PANEL.instantiate()
			p.update_panel(q)
			quest_container.add_child(p)
