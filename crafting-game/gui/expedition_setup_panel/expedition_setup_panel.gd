extends Control
class_name ExpeditionSetupPanel


@onready var location_button: OptionButton = %LocationButton
@onready var task_button: OptionButton = %TaskButton
@onready var hero_grid_container: VBoxContainer = %HeroGridContainer
@onready var food_counter: Label = %FoodCounter
@onready var food_slider: HSlider = %FoodSlider


func _ready() -> void:
	GameManager.resource_changed.connect(_on_resource_changed)
	_update_slider_max()

func _process(_delta: float) -> void:
	food_counter.text = str(int(food_slider.value))

func _on_resource_changed(r: String) -> void:
	if r == "food":
		_update_slider_max()

func _update_food_counter() -> void:
	food_counter.text = str(int(food_slider.value))

func _update_slider_max() -> void:
	food_slider.max_value = GameManager.resources["food"]

# TODO: setup dropdown buttons
# TODO: Setup party select
