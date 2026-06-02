extends Control
class_name PartyMemberSelectPanel

signal hero_selected(h: HeroData)

const HERO_SELECT_BUTTON : PackedScene = preload("uid://cnxvb41xlyhxn")

@export var hero_button_container: VBoxContainer

var quest : Quest

func _ready() -> void:
	_populate_heroes()
	show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and visible:
		_close_window()

func _clear_list() -> void:
	for c in hero_button_container.get_children():
		c.queue_free()

func _close_window() -> void:
	queue_free()

func _on_hero_button_pressed(h: HeroData) -> void:
	if quest.party.add_party_member(h):
		hero_selected.emit(h)
		_close_window()
	else:
		pass # TODO: Add button shake and red hue to show it was an invalid choice

func _populate_heroes() -> void:
	_clear_list()
	for h: HeroData in HeroManager.get_available_heroes():
		var b : HeroSelectButton = HERO_SELECT_BUTTON.instantiate()
		b.setup_button(h)
		b.pressed.connect(_on_hero_button_pressed)
		hero_button_container.add_child(b)
