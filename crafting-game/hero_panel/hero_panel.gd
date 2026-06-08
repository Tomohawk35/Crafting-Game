extends PanelContainer
class_name HeroPanel

var hero : HeroData

@onready var name_label: Label = %NameLabel
@onready var class_label: Label = %ClassLabel
@onready var level_label: Label = %LevelLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel
@onready var equipment_container_1: VBoxContainer = %EquipmentContainer1
@onready var equipment_container_2: VBoxContainer = %EquipmentContainer2
@onready var all_stat_container: VBoxContainer = %AllStatContainer

func _ready() -> void:
	for c: ItemSlotUI in equipment_container_1.get_children():
		c.pressed.connect(_show_equipment_data)
	for c: ItemSlotUI in equipment_container_2.get_children():
		c.pressed.connect(_show_equipment_data)

func _show_equipment_data(s: SlotData) -> void:
	if s.item == null:
		return
	EventBus.display_equipment.emit(s, hero)

func update_panel(h: HeroData) -> void:
	hero = h
	name_label.text = hero.hero_name + ", " + hero.hero_title
	name_label.modulate = Constants.RARITY_COLORS[hero.rarity]
	class_label.text = hero.hero_job.job_name
	level_label.text = str(hero.level)
	strength_label.text = str(int(round(hero.total_stats.stats["strength"])))
	dexterity_label.text = str(int(round(hero.total_stats.stats["dexterity"])))
	intelligence_label.text = str(int(round(hero.total_stats.stats["intelligence"])))
	charisma_label.text = str(int(round(hero.total_stats.stats["charisma"])))
	
	for c in all_stat_container.get_children():
		c.queue_free()
	
	var l : Label
	for stat in hero.total_stats.stats.keys():
		if hero.total_stats.stats[stat] > 0.0: # TODO: Only show quest related stats?
			l = Label.new()
			l.text = stat + ": " + str(hero.total_stats.stats[stat])
			#l.text = _format_stat(affix.affix_data.stat_name, affix.value)
			#l.set_label_text(stat, str(hero.total_stats.stats[stat]))
			all_stat_container.add_child(l)
	
	
	#var s : SlotData
	
	for c: ItemSlotUI in equipment_container_1.get_children():
		if c is not ItemSlotUI or c.is_equipment_slot == false:
			continue
		#s = SlotData.new()
		if hero.equipment[c.equipment_type]:
			c.set_slot_data(hero.equipment[c.equipment_type])
		else:
			c.set_slot_data(SlotData.new())
			#s.item = hero.equipment[c.equipment_type]
			#c.set = hero.equipment[c.equipment_type]
		#c.set_slot_data(s)
	
	for c: ItemSlotUI in equipment_container_2.get_children():
		if c is not ItemSlotUI or c.is_equipment_slot == false:
			continue
		#s = SlotData.new()
		#if hero.equipment[c.equipment_type]:
			#s.item = hero.equipment[c.equipment_type]
		#c.set_slot_data(s)
		if hero.equipment[c.equipment_type]:
			c.set_slot_data(hero.equipment[c.equipment_type])
		else:
			c.set_slot_data(SlotData.new())
	
	#if hero.helmet:
		#s = SlotData.new()
		#s.item = hero.helmet
	#else:
		#s = null
	#helmet_slot.set_slot_data(s)
	#
	#if hero.weapon:
		#s = SlotData.new()
		#s.item = hero.weapon
	#else:
		#s = null
	#weapon_slot.set_slot_data(s)
	#
	#if hero.ring:
		#s = SlotData.new()
		#s.item = hero.ring
	#else:
		#s = null
	#ring_slot.set_slot_data(s)
	#
	#if hero.gloves:
		#s = SlotData.new()
		#s.item = hero.gloves
	#else:
		#s = null
	#gloves_slot.set_slot_data(s)
	#
	#if hero.amulet:
		#s = SlotData.new()
		#s.item = hero.amulet
	#else:
		#s = null
	#amulet_slot.set_slot_data(s)
	#
	#if hero.shield:
		#s = SlotData.new()
		#s.item = hero.shield
	#else:
		#s = null
	#shield_slot.set_slot_data(s)
	#
	#if hero.body_armor:
		#s = SlotData.new()
		#s.item = hero.body_armor
	#else:
		#s = null
	#body_armor_slot.set_slot_data(s)
	
