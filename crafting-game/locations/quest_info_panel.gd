extends PanelContainer
class_name QuestInfoPanel

const PARTY_MEMBER_SELECT_PANEL : PackedScene = preload("uid://cy17x5fgp1kr2")
const QUEST_PARTY_MEMBER_BUTTON : PackedScene = preload("uid://phfrfmduowvq")
const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")

@export var ui_root : CanvasLayer

var data : Quest

@export var quest_name_label: Label
@export var quest_description_label: Label
@export var party_member_button_container: VBoxContainer
@export var resource_reward_container: VBoxContainer
@export var reward_container: GridContainer
@export var start_quest_button: Button

var temp_party : Array[HeroData] = []
var target_hero_slot : int

# TODO: Change ItemSlotUI to a DisplaySlot instead. Don't need drag/drop functionality

func _ready() -> void:
	start_quest_button.pressed.connect(_on_start_quest_button_pressed)
	QuestManager.quest_started.connect(_on_quest_started)

func _on_party_member_button_pressed(i: int) -> void:
	target_hero_slot = i
	var hero_select_panel : PartyMemberSelectPanel = PARTY_MEMBER_SELECT_PANEL.instantiate()
	hero_select_panel.quest = data
	hero_select_panel.hero_selected.connect(_on_hero_selected)
	ui_root.add_child(hero_select_panel)

func _on_quest_started(q: Quest) -> void:
	print("quest started signal received")
	if data == q:
		start_quest_button.disabled = true

func _on_hero_selected(h: HeroData) -> void:
	if h and !temp_party.has(h):
		temp_party[target_hero_slot] = h
		_update_button_names()
	target_hero_slot = -1
	#EventBus.hero_selected.disconnect(_on_hero_selected) 
	# TODO: Remove hero from available hero list?

func _update_button_names() -> void:
	var button_list : Array = party_member_button_container.get_children()
	for i in button_list.size():
		if temp_party[i] and temp_party[i] != null:
			button_list[i].text = temp_party[i].get_formatted_name()

func _on_start_quest_button_pressed() -> void:
	if temp_party.count(null) >= temp_party.size():
		print("Cannot start quest. No party members.")
		return
	
	#for slot in temp_party:
		#if slot:
			#slot.on_quest = true
			#data.add_party_member(slot)
	#data.state = Quest.QuestState.TRAVELING
	QuestManager.start_quest(data)
	print("Quest Started")

func update_panel(q: Quest) -> void:
	data = q
	for c in party_member_button_container.get_children():
		c.queue_free()
	for c in reward_container.get_children():
		c.queue_free()
	temp_party.clear()
	quest_name_label.text = data.quest_title
	quest_description_label.text = data.get_description()
	for i in range(data.party_size):
		var b : QuestPartyMemberButton = QUEST_PARTY_MEMBER_BUTTON.instantiate()
		b.text = "Party Member " + str(i + 1)
		b.index = i
		#b.mouse_entered.connect(func(): b.grab_focus())
		#b.mouse_exited.connect(func(): b.release_focus())
		b.pressed.connect(
			func():
				print(b.text + " pressed.")
				target_hero_slot = b.index
				_on_party_member_button_pressed(b.index)
				)
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
