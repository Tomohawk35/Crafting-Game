extends Control
class_name ExpeditionSetupPanel


@onready var location_button: OptionButton = %LocationButton
@onready var task_button: OptionButton = %TaskButton
@onready var party_select_button: OptionButton = %PartySelectButton
@onready var hero_grid_container: VBoxContainer = %HeroGridContainer
@onready var food_counter: Label = %FoodCounter
@onready var food_slider: HSlider = %FoodSlider
@onready var start_button: Button = %StartButton


func _ready() -> void:
	HeroManager.create_party()
	HeroManager.create_party()
	GameManager.resource_changed.connect(_on_resource_changed)
	_update_slider_max()
	_setup_location_button()
	_setup_task_button()
	_setup_party_button()
	start_button.pressed.connect(_on_start_button_pressed)

func _process(_delta: float) -> void:
	food_counter.text = str(int(food_slider.value))

func _on_resource_changed(r: String) -> void:
	if r == "food":
		_update_slider_max()

func _update_food_counter() -> void:
	food_counter.text = str(int(food_slider.value))

func _update_slider_max() -> void:
	food_slider.max_value = GameManager.resources["food"]

func _setup_location_button() -> void:
	location_button.clear()
	for loc in Constants.Locations.values(): # TODO: Need to do this based on unlocked locations
		location_button.add_item(Constants.LOCATION_ENUM_STRING[loc], loc)

func _setup_task_button() -> void:
	task_button.clear()
	var task_keys : Array = Expedition.Tasks.keys()
	for t in Expedition.Tasks.values():
		task_button.add_item(task_keys[t].capitalize(), t)

func _setup_party_button() -> void:
	party_select_button.clear()
	for p : Party in HeroManager.parties:
		party_select_button.add_item(p.party_name)

func _on_start_button_pressed() -> void:
	# Create expedition and start it
	var e : Expedition = Expedition.new()
	e.set_location(location_button.selected)
	e.set_food_reserves(floori(food_slider.value))
	e.set_party(HeroManager.parties[party_select_button.selected])
	e.set_task(task_button.selected)
	ExpeditionManager.start_expedition(e)
	pass

func open(loc: Constants.Locations) -> void:
	_update_slider_max()
	_setup_location_button()
	_setup_task_button()
	_setup_party_button()
	# TODO: Select passed location as target location
	location_button.selected = loc
	show()

func close() -> void: 
	hide()
