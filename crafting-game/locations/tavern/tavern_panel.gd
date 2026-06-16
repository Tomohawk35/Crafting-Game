extends Control
class_name TavernPanel

const PANEL_LABEL : PackedScene = preload("uid://ej4wowvxpjnd")
const RECRUIT_HERO_CARD : PackedScene = preload("uid://ga03mwgqir1n")

const MAX_RECRUITABLE_HEROES : int = 3

var data: BuildingData

@onready var level_value_label: Label = %LevelValueLabel
@onready var cost_to_upgrade_header: Label = %CostToUpgradeHeader
@onready var upgrade_cost_container: VBoxContainer = %UpgradeCostContainer
@onready var upgrade_button: Button = %UpgradeButton
@onready var hero_recruit_card_container: HBoxContainer = %HeroRecruitCardContainer

func _ready() -> void:
	for child in upgrade_cost_container.get_children():
		child.queue_free()
	for child in hero_recruit_card_container.get_children():
		child.queue_free()
	upgrade_button.disabled = true
	data = GameManager.buildings[Constants.Buildings.TAVERN]
	data.leveled_up.connect(_update_panel)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	hide()

func _on_upgrade_button_pressed() -> void:
	for r in data.level_up_resource_cost.keys():
		if !GameManager.has_resources(r, data.level_up_resource_cost[r]):
			return 
	for r in data.level_up_resource_cost.keys():
		GameManager.remove_resources(r, data.level_up_resource_cost[r])
	data.level_up()
	_generate_recruitable_heroes() # TODO: Need to setup persistant data for hero cards

func _update_panel() -> void:
	level_value_label.text = str(data.level)
	if data.is_max_level:
		cost_to_upgrade_header.hide()
		upgrade_cost_container.hide()
		upgrade_button.disabled = true
	else:
		for child in upgrade_cost_container.get_children():
			child.queue_free()
		var l : PanelLabel
		for key: String in data.level_up_resource_cost.keys():
			l = PANEL_LABEL.instantiate()
			l.text_label.text = key.capitalize() + ": "
			l.value_label.text = "%.0f" % (data.level_up_resource_cost[key])
			upgrade_cost_container.add_child(l)
		cost_to_upgrade_header.show()
		upgrade_cost_container.show()
		upgrade_button.disabled = false

func _generate_recruitable_heroes() -> void: # TODO: Incorporate tavern level
	for child in hero_recruit_card_container.get_children():
		child.queue_free()
	for i in range(MAX_RECRUITABLE_HEROES):
		var c : RecruitHeroCard = RECRUIT_HERO_CARD.instantiate() as RecruitHeroCard
		var h : HeroData = HeroFactory.generate_hero()
		c.hero_data = h
		c.recruit_cost = HeroFactory.calculate_recruit_cost(h)
		hero_recruit_card_container.add_child(c)

func _create_hero_card(h: HeroData) -> RecruitHeroCard:
	var card : RecruitHeroCard = RECRUIT_HERO_CARD.instantiate() as RecruitHeroCard
	card.set_data(h)
	#card.recruit_cost = HeroFactory.calculate_recruit_cost(h)
	return card

#func _calculate_recruit_cost(h: HeroData) -> int:
	#return (h.rarity + 1) * h.level * 10
	# TODO: Maybe add a cost reduction into the tavern level or some town value

func open() -> void:
	_update_panel()
	show()

func close() -> void:
	hide()
