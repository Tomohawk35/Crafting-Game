extends PanelContainer
class_name RecruitHeroCard

var hero_data : HeroData
var recruit_cost : int = 745

@onready var adventurer_name_label: Label = %AdventurerNameLabel
@onready var level_label: Label = %LevelLabel
@onready var adventurer_sprite: TextureRect = %AdventurerSprite
@onready var str_value_label: Label = %StrValueLabel
@onready var dex_value_label: Label = %DexValueLabel
@onready var int_value_label: Label = %IntValueLabel
@onready var cha_value_label: Label = %ChaValueLabel
@onready var recruit_cost_label: Label = %RecruitCostLabel
@onready var recruit_button: Button = %RecruitButton
@onready var grey_filter_panel: Panel = %GreyFilterPanel


func _ready() -> void:
	if hero_data:
		_update_card()
	recruit_button.pressed.connect(_on_recruit_button_pressed)

func _update_card() -> void:
	adventurer_name_label.text = hero_data.hero_name + ", " + hero_data.hero_title # TODO: format based on rarity
	level_label.text = str(hero_data.level)
	# TODO: Update texture, add hero icon to data
	str_value_label.text = str(int(round(hero_data.total_stats.stats["strength"])))
	dex_value_label.text = str(int(round(hero_data.total_stats.stats["dexterity"])))
	int_value_label.text = str(int(round(hero_data.total_stats.stats["intelligence"])))
	cha_value_label.text = str(int(round(hero_data.total_stats.stats["charisma"])))
	recruit_cost_label.text = str(recruit_cost) # TODO: Need to calculate recruit cost somewhere

func _on_recruit_button_pressed() -> void:
	#if GameManager.has_gold(recruit_cost): 
		#GameManager.remove_gold(recruit_cost)
	if GameManager.has_resources("gold", recruit_cost):
		GameManager.remove_resources("gold", recruit_cost)
		GameManager.hero_roster.append(hero_data)
		grey_filter_panel.visible = true
		recruit_button.disabled = true
	# TODO: Add red color and shake effect if not enough gold

# TODO: Add a way to replace/reroll recruitable heroes
