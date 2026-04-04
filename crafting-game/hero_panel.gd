extends Control
class_name HeroPanel

@onready var name_label: Label = %NameLabel
@onready var class_label: Label = %ClassLabel
@onready var level_label: Label = %LevelLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel

func update_panel(hero: HeroData) -> void:
	name_label.text = hero.hero_name + ", " + hero.hero_title
	name_label.modulate = Constants.RARITY_COLORS[hero.rarity]
	class_label.text = hero.hero_job.job_name
	level_label.text = str(hero.level)
	strength_label.text = str(int(round(hero.strength)))
	dexterity_label.text = str(int(round(hero.dexterity)))
	intelligence_label.text = str(int(round(hero.intelligence)))
	charisma_label.text = str(int(round(hero.charisma)))
