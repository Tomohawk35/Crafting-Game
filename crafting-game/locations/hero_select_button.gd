extends PanelContainer
class_name HeroSelectButton

signal pressed(h: HeroData)

var data : HeroData

@export var hero_name_label: Label
@export var level_value_label: Label
@export var str_value_label: Label
@export var dex_value_label: Label
@export var int_value_label: Label
@export var cha_value_label: Label
@export var hero_sprite: TextureRect


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		print(hero_name_label.text + " button pressed.")
		pressed.emit(data)

func setup_button(h: HeroData) -> void:
	data = h
	hero_name_label.text = data.get_formatted_name()
	level_value_label.text = str(data.level)
	str_value_label.text = str(data.total_stats.stats["strength"])
	dex_value_label.text = str(data.total_stats.stats["dexterity"])
	int_value_label.text = str(data.total_stats.stats["intelligence"])
	cha_value_label.text = str(data.total_stats.stats["charisma"])
	# TODO: Update hero sprite
