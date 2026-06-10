extends PanelContainer
class_name EquipmentTooltip

const OFFSET : Vector2 = Vector2.ONE * 0.0 # TODO: Dial in to match custom cursor
const TWEEN_DURATION : float = 0.2
const MAX_ALPHA : float = 0.95

var opacity_tween : Tween = null

@onready var item_name_label: Label = %ItemNameLabel
@onready var description_label: RichTextLabel = %DescriptionLabel

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

func _set_item_display(i: Item) -> void: # BUG : Tooltip window doesn't display with correct sizing
	if i is Equipment:
		item_name_label.text = i.item_name
		item_name_label.modulate = i.get_color()
		description_label.parse_bbcode(i.description_string)
		#queue_sort()
		reset_size()

func toggle(on : bool) -> void:
	if on:
		show()
		#reset_size()
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
