extends Control
class_name ItemTooltip

@onready var name_label: Label = %NameLabel
@onready var rarity_label: Label = %RarityLabel
@onready var stats_box: VBoxContainer = %StatsBox

func set_item(item: ItemInstance) -> void:
	name_label.text = item.get_display_name()
	name_label.modulate = item.get_color()
	rarity_label.text = Constants.Rarity.keys()[item.rarity].capitalize()
	
	_clear_stats()
	
	for stat_name in item.rolled_stats.keys():
		var value = item.rolled_stats[stat_name]
		var l : Label = Label.new()
		l.text = _format_stat(stat_name, value)
		stats_box.add_child(l)

func _clear_stats() -> void:
	for c in stats_box.get_children():
		c.queue_free()

func _format_stat(stat_name: String, value: float) -> String:
	var display : String = stat_name.replace("_", " ").capitalize()
	
	if stat_name.ends_with("_pct"):
		return "+%d%% %s" % [round(value), display.replace(" Pct", "")]
	
	return "+%d %s" % [round(value), display]
