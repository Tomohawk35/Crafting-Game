extends PanelContainer
class_name EquipmentTooltip

const OFFSET : Vector2 = Vector2.ONE * 0.0 # TODO: Dial in to match custom cursor
const TWEEN_DURATION : float = 0.2
const MAX_ALPHA : float = 0.3

var opacity_tween : Tween = null

@onready var name_label: Label = %NameLabel
@onready var rarity_label: Label = %RarityLabel
@onready var stats_box: VBoxContainer = %StatsBox
@onready var affix_box: VBoxContainer = %AffixBox
#@onready var item_icon: TextureRect = %ItemIcon

func _ready() -> void:
	EventBus.hide_tooltip.connect(_on_hide_tooltip)
	EventBus.show_tooltip.connect(_on_show_tooltip)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func _on_show_tooltip(c: Control) -> void:
	if c is ItemSlotUI and c.slot_data.item:
		_set_item_display(c.slot_data.item)
		toggle(true)

func _on_hide_tooltip() -> void:
	toggle(false)

func _set_item_display(i: Item) -> void: # TODO : Change to using a single rich text label
	if i is Equipment:
		name_label.text = i.item_name
		name_label.modulate = i.get_color()
		rarity_label.text = Constants.Rarity.keys()[i.rarity].capitalize()
		_clear_stats()
	
		for affix in i.implicit_affixes:
			#var value = item.rolled_stats[stat_name]
			var l : Label = Label.new()
			l.text = _format_stat(affix.affix_data.stat_name, affix.value)
			stats_box.add_child(l)
		
		for affix in i.explicit_affixes:
			var l : Label = Label.new()
			#l.text = affix.affix_data.description % round(affix.value)
			l.text = _format_stat(affix.affix_data.stat_name, affix.value)
			affix_box.add_child(l)

func toggle(on : bool) -> void:
	if on:
		show()
		modulate.a = 0.0
		tween_opacity(MAX_ALPHA)
	else:
		modulate.a = MAX_ALPHA
		await tween_opacity(0.0).finished
		hide()

func tween_opacity(to : float) -> Tween:
	if opacity_tween :
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, TWEEN_DURATION)
	return opacity_tween




func set_item(item: Equipment) -> void:
	name_label.text = item.item_name
	name_label.modulate = item.get_color()
	rarity_label.text = Constants.Rarity.keys()[item.rarity].capitalize()
	#item_icon.texture = item.icon
	
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
			return "%.2f%% Increased %s" % [value, display.replace(" Pct", "")]
		else:
			return "%d%% Decreased %s" % [value, display.replace(" Pct", "")]
	
	if value > 0:
		return "+%d %s" % [round(value), display]
	else:
		return "-%d %s" % [round(value), display]
