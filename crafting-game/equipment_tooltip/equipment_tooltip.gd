extends Control
class_name EquipmentTooltip

@onready var name_label: Label = %NameLabel
@onready var rarity_label: Label = %RarityLabel
@onready var stats_box: VBoxContainer = %StatsBox
@onready var affix_box: VBoxContainer = %AffixBox

func set_item(item: EquipmentInstance) -> void:
	name_label.text = item.base_equipment.item_name
	name_label.modulate = item.get_color()
	rarity_label.text = Constants.Rarity.keys()[item.rarity].capitalize()
	
	_clear_stats()
	
	for affix in item.implicit_affixes:
		#var value = item.rolled_stats[stat_name]
		var l : Label = Label.new()
		l.text = _format_stat(affix.affix_data.stat_name, affix.value)
		stats_box.add_child(l)
	
	for affix in item.explicit_affixes:
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
			return "%d%% Increased %s" % [round(value), display.replace(" Pct", "")]
		else:
			return "%d%% Decreased %s" % [round(value), display.replace(" Pct", "")]
	
	if value > 0:
		return "+%d %s" % [round(value), display]
	else:
		return "-%d %s" % [round(value), display]
