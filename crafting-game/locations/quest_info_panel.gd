extends PanelContainer
class_name QuestInfoPanel

#const PARTY_MEMBER_SELECT_PANEL : PackedScene = preload("uid://cy17x5fgp1kr2")
const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")

var data : Quest

@export var quest_name_label: Label
@export var quest_description_label: Label
@export var party_member_button_container: VBoxContainer
@export var resource_reward_container: VBoxContainer
@export var reward_container: GridContainer

var temp_party : Array[HeroData] = []
var target_hero_slot : int

# TODO: Add Start Quest button
# TODO: Change ItemSlotUI to a DisplaySlot instead. Don't need drag/drop functionality

func _ready() -> void:
	#var q: Quest = Quest.new()
	#q.add_resource_reward("gold", 134)
	#q.add_resource_reward("wood", 44)
	#q.add_resource_reward("stone", 23)
	#q.add_item_reward(ItemGenerator.generate_equipment())
	#q.add_item_reward(ItemGenerator.generate_equipment())
	#q.add_item_reward(ItemGenerator.generate_equipment())
	#q.add_item_reward(ItemGenerator.generate_equipment())
	#update_panel(q) # TODO: Remove after testing
	pass

func _on_party_member_button_pressed(i: int) -> void:
	target_hero_slot = i
	EventBus.open_select_hero_window.emit()
	EventBus.hero_selected.connect(_on_hero_selected)

func _on_hero_selected(h: HeroData) -> void:
	if h:
		temp_party[target_hero_slot] = h
		_update_button_names()
	target_hero_slot = -1
	EventBus.hero_selected.disconnect(_on_hero_selected)

func _update_button_names() -> void:
	var button_list : Array = party_member_button_container.get_children()
	for i in button_list.size():
		if temp_party[i] and temp_party[i] != null:
			button_list[i].text = temp_party[i].get_formatted_name()

func update_panel(q: Quest) -> void:
	data = q
	for c in party_member_button_container.get_children():
		c.queue_free()
	for c in reward_container.get_children():
		c.queue_free()
	quest_name_label.text = data.quest_name
	quest_description_label.text = data.quest_description
	for i in range(data.party_size):
		var b : Button = Button.new()
		b.text = "Party Member " + str(i + 1)
		b.index = i
		b.pressed.connect(func():
			target_hero_slot = b.index
			_on_party_member_button_pressed(b.index))
		party_member_button_container.add_child(b)
		temp_party.append(null)
	
	for reward : String in data.resource_rewards.keys(): # TODO: Change this to use slots
		var l : Label = Label.new()
		l.text = reward.capitalize() + ": " + str(data.resource_rewards[reward])
		resource_reward_container.add_child(l)
	
	for reward : SlotData in data.item_rewards:
		var slot_ui : ItemSlotUI = ITEM_SLOT_UI.instantiate()
		slot_ui.slot_data = reward
		slot_ui.update()
		reward_container.add_child(slot_ui)
