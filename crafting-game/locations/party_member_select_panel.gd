extends Control
class_name PartyMemberSelectPanel

#signal hero_selected(h: HeroData)
#signal window_closed

const HERO_SELECT_BUTTON : PackedScene = preload("uid://cnxvb41xlyhxn")

@export var hero_button_container: VBoxContainer

func _ready() -> void:
	_clear_list()
	hide()
	EventBus.open_select_hero_window.connect(_on_open_select_hero_window_signal)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and visible:
		_close_window()

func _on_open_select_hero_window_signal() -> void:
	populate_heroes()
	show()

func _close_window() -> void:
	EventBus.hero_selected.emit(null)
	_clear_list()
	hide()
	#window_closed.emit()

func _clear_list() -> void:
	for c in hero_button_container.get_children():
		if c is HeroSelectButton:
			c.pressed.disconnect(_on_hero_button_pressed)
		c.queue_free()

func _on_hero_button_pressed(h: HeroData) -> void:
	EventBus.hero_selected.emit(h)
	#_clear_list()
	#hide()
	_close_window()

func populate_heroes() -> void:
	_clear_list()
	for h: HeroData in HeroManager.get_available_heroes():
		var b : HeroSelectButton = HERO_SELECT_BUTTON.instantiate()
		b.setup_button(h)
		b.pressed.connect(_on_hero_button_pressed)
		hero_button_container.add_child(b)
