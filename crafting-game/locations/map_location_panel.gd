extends Control
class_name MapLocationPanel

const QUEST_INFO_PANEL : PackedScene = preload("uid://d3vkayuk7ieia")

@export var name_label: Label
@export var description_label: Label
@export var favor_value_label: Label
@export var no_quests_available_label: Label
@export var quest_container: VBoxContainer
@export var quest_scroll_container: ScrollContainer

var location_id : String
var data : LocationData

func _ready() -> void:
	EventBus.location_clicked.connect(_on_location_clicked)
	hide()

func _on_location_clicked(l: String) -> void:
	if GameManager.locations.has(l):
		_clear_quest_list()
		location_id = l
		update_panel(GameManager.locations[location_id])
		show()

func _clear_quest_list() -> void:
	for child in quest_container.get_children():
		child.queue_free()

func _load_quests() -> void:
	var quest_list : Array[Quest] = QuestManager.get_location_quests(location_id)
	if quest_list.size() == 0:
		no_quests_available_label.show()
		quest_scroll_container.hide()
		quest_container.hide()
	else:
		no_quests_available_label.hide()
		quest_scroll_container.show()
		quest_container.show()
		for q: Quest in quest_list:
			var p: QuestInfoPanel = QUEST_INFO_PANEL.instantiate()
			p.update_panel(q)
			quest_container.add_child(p)

func update_panel(d: LocationData) -> void:
	data = d
	name_label.text = data.location_name.capitalize()
	description_label.text = data.description
	favor_value_label.text = str(data.favor)
	_load_quests()
