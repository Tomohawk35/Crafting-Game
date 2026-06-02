extends Control
class_name PlayerHUD

@onready var gold_value_label: Label = %GoldValueLabel
@onready var wood_value_label: Label = %WoodValueLabel
@onready var stone_value_label: Label = %StoneValueLabel
@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	_set_gold_value()
	_set_wood_value()
	_set_stone_value()
	_update_time()
	#GameManager.gold_changed.connect(_set_gold_value)
	GameManager.resource_changed.connect(_on_resource_changed)
	TimeManager.tick.connect(_update_time)

func _on_resource_changed(r: String) -> void:
	match r:
		"gold":
			_set_gold_value()
		"wood":
			_set_wood_value()
		"stone":
			_set_stone_value()
		_:
			pass

func _set_gold_value() -> void:
	gold_value_label.text = str(GameManager.resources["gold"])

func _set_wood_value() -> void:
	wood_value_label.text = str(GameManager.resources["wood"])

func _set_stone_value() -> void:
	stone_value_label.text = str(GameManager.resources["stone"])

func _update_time(_h: int = 0, _m: int = 0) -> void:
	time_label.text = TimeManager.get_formatted_time()

# TODO: Change gold text label with gold icon
# TODO: Add indicators for other resources (wood, stone, etc)
