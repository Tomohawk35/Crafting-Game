extends Control

var hero : HeroData
var equipment : Equipment

@onready var name_label: Label = %NameLabel
@onready var rarity_label: Label = %RarityLabel
@onready var item_icon: TextureRect = %ItemIcon
@onready var stats_box: VBoxContainer = %StatsBox
@onready var affix_box: VBoxContainer = %AffixBox

func _ready() -> void:
	EventBus.display_equipment.connect(_on_display_equipment)

func _on_display_equipment(s: SlotData, h: HeroData) -> void:
	hero = h
	set_item(s.item)
	show()

func set_item(e: Equipment) -> void:
	equipment = e
	name_label.text = equipment.item_name
	name_label.modulate = equipment.get_color()
	rarity_label.text = Constants.Rarity.keys()[equipment.rarity].capitalize()
	item_icon.texture = equipment.icon
	
	_clear_stats()
	
	for affix in equipment.implicit_affixes:
		#var value = item.rolled_stats[stat_name]
		var l : Label = Label.new()
		l.text = _format_stat(affix.affix_data.stat_name, affix.value)
		stats_box.add_child(l)
	
	for affix in equipment.explicit_affixes:
		var l : Label = Label.new()
		#l.text = affix.affix_data.description % round(affix.value)
		l.text = _format_stat(affix.affix_data.stat_name, affix.value)
		affix_box.add_child(l)

func _clear_stats() -> void:
	for c in stats_box.get_children():
		c.queue_free()
	for c in affix_box.get_children():
		c.queue_free()

func _format_stat(stat_name: String, value: float) -> String:
	var display : String = stat_name.replace("_", " ").capitalize()
	
	if stat_name.ends_with("_pct"):
		if value > 0:
			return "%.2f%% Increased %s" % [value, display.replace(" Pct", "")]
		else:
			return "%d%% Decreased %s" % [value, display.replace(" Pct", "")]
	
	if value > 0:
		return "+%d %s" % [round(value), display]
	else:
		return "-%d %s" % [round(value), display]
