extends Control
class_name HeroPanel

@onready var name_label: Label = %NameLabel
@onready var class_label: Label = %ClassLabel
@onready var level_label: Label = %LevelLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel

@onready var helmet_slot: ItemSlotUI = %HelmetSlot
@onready var weapon_slot: ItemSlotUI = %WeaponSlot
@onready var ring_slot: ItemSlotUI = %RingSlot
@onready var character_sprite: TextureRect = %CharacterSprite
@onready var amulet_slot: ItemSlotUI = %AmuletSlot
@onready var shield_slot: ItemSlotUI = %ShieldSlot
@onready var body_armor_slot: ItemSlotUI = %BodyArmorSlot
@onready var gloves_slot: ItemSlotUI = %GlovesSlot

func update_panel(hero: HeroData) -> void:
	name_label.text = hero.hero_name + ", " + hero.hero_title
	name_label.modulate = Constants.RARITY_COLORS[hero.rarity]
	class_label.text = hero.hero_job.job_name
	level_label.text = str(hero.level)
	strength_label.text = str(int(round(hero.total_strength)))
	dexterity_label.text = str(int(round(hero.total_dexterity)))
	intelligence_label.text = str(int(round(hero.total_intelligence)))
	charisma_label.text = str(int(round(hero.total_charisma)))
	
	var s : SlotData
	
	if hero.helmet:
		s = SlotData.new()
		s.item = hero.helmet
	else:
		s = null
	helmet_slot.set_slot_data(s)
	
	if hero.weapon:
		s = SlotData.new()
		s.item = hero.weapon
	else:
		s = null
	weapon_slot.set_slot_data(s)
	
	if hero.ring:
		s = SlotData.new()
		s.item = hero.ring
	else:
		s = null
	ring_slot.set_slot_data(s)
	
	if hero.gloves:
		s = SlotData.new()
		s.item = hero.gloves
	else:
		s = null
	gloves_slot.set_slot_data(s)
	
	if hero.amulet:
		s = SlotData.new()
		s.item = hero.amulet
	else:
		s = null
	amulet_slot.set_slot_data(s)
	
	if hero.shield:
		s = SlotData.new()
		s.item = hero.shield
	else:
		s = null
	shield_slot.set_slot_data(s)
	
	if hero.body_armor:
		s = SlotData.new()
		s.item = hero.body_armor
	else:
		s = null
	body_armor_slot.set_slot_data(s)
	
