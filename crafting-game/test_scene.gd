extends Control

var generator : ItemGenerator
var item : Equipment
var hero : HeroData

@onready var equipment_tooltip: EquipmentTooltip = $EquipmentTooltip
@onready var generate_button: Button = $GenerateButton
@onready var add_button: Button = $AddButton
@onready var remove_button: Button = $RemoveButton
@onready var create_hero_button: Button = $CreateHeroButton
@onready var hero_panel: HeroPanel = $HeroPanel
@onready var level_up_button: Button = $LevelUpButton

func _ready() -> void:
	generate_button.pressed.connect(_on_generate_button_pressed)
	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)
	create_hero_button.pressed.connect(_on_create_hero_button_pressed)
	level_up_button.pressed.connect(_on_level_up_button_pressed)

func _on_generate_button_pressed() -> void:
	if !hero:
		return
	if item:
		item.stats_updated.disconnect(_update_tooltip)
	item = ItemGenerator.generate_equipment()
	item.stats_updated.connect(_update_tooltip)
	item._update_stats()
	hero.equip_item(item)

func _update_tooltip() -> void:
	if item == null:
		return
	equipment_tooltip.set_item(item)

func _on_add_button_pressed() -> void:
	item.add_affix()

func _on_remove_button_pressed() -> void:
	item.remove_affix()

func _on_create_hero_button_pressed() -> void:
	if hero:
		hero.stats_updated.disconnect(_on_hero_stats_updated)
	hero = HeroData.new()
	hero.hero_name = HeroData.HERO_NAMES.pick_random()
	hero.hero_title = HeroData.HERO_TITLES.pick_random()
	hero.hero_job = GameDB.HERO_JOBS.pick_random()
	hero.level = randi_range(1, 8)
	hero.rarity = Constants.Rarity.values()[randi_range(0, Constants.Rarity.size() - 1)]
	hero.set_base_stats()
	hero.get_initial_stats()
	hero.get_total_stats()
	hero_panel.update_panel(hero)
	hero.stats_updated.connect(_on_hero_stats_updated)

func _on_level_up_button_pressed() -> void:
	hero.level_up()

func _on_hero_stats_updated() -> void:
	hero_panel.update_panel(hero)

# Should these methods be here or should they be in the 
# item generator?
