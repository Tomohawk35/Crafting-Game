extends Control
class_name MapLocationPanel

const QUEST_INFO_PANEL : PackedScene = preload("uid://d3vkayuk7ieia")

@export var name_label: Label
@export var description_label: Label
@export var favor_value_label: Label
@export var no_quests_available_label: Label
@export var quest_container: VBoxContainer
@export var quest_scroll_container: ScrollContainer
@export var ui_root : CanvasLayer

var location_id : Constants.Locations
var data : LocationData

@onready var send_expedition_button: Button = %SendExpeditionButton

func _ready() -> void:
	hide()
	send_expedition_button.pressed.connect(_on_send_expedition_button_pressed)

func _clear_quest_list() -> void:
	for child in quest_container.get_children():
		child.queue_free()

func open() -> void:
	if location_id:
		_clear_quest_list()
		update_panel()
		show()

func close() -> void:
	hide()

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
			p.ui_root = ui_root
			p.update_panel(q)
			quest_container.add_child(p)

func _on_send_expedition_button_pressed() -> void:
	pass

func update_panel() -> void:
	data = GameManager.locations[location_id]
	name_label.text = data.location_name.capitalize()
	description_label.text = data.description
	favor_value_label.text = str(data.favor)
	_load_quests()

func set_location(l: Constants.Locations) -> void:
	location_id = l
	if visible:
		update_panel()
