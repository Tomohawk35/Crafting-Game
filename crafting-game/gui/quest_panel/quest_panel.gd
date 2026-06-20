extends Control
class_name QuestPanel

const ITEM_SLOT_UI : PackedScene = preload("uid://cq60rwikmkkud")

var displayed_quest : Quest

@onready var quest_button_container: VBoxContainer = %QuestButtonContainer

@onready var quest_title_label: Label = %QuestTitleLabel
@onready var quest_description_label: Label = %QuestDescriptionLabel
@onready var quest_state_label: Label = %QuestStateLabel
@onready var item_reward_container: GridContainer = %ItemRewardContainer
@onready var collect_rewards_button: Button = %CollectRewardsButton

# TODO: Add a Go To button to center camera on target location or village

func _ready() -> void:
	hide()

func _load_quests() -> void:
	for child in quest_button_container.get_children():
		child.queue_free()
	var b : Button
	for q : Quest in QuestManager.quests:
		b = Button.new()
		b.text = q.quest_title
		if q.state == Quest.QuestState.COMPLETE:
			b.modulate = Color.GOLD
		quest_button_container.add_child(b)
		b.pressed.connect(_on_quest_button_pressed.bind(q))

func _on_quest_button_pressed(q: Quest) -> void:
	quest_title_label.text = q.quest_title
	quest_description_label.text = q.get_description()
	quest_state_label.text = Quest.QuestState.keys()[q.state].capitalize()
	#var l : Label
	#for r in q.resource_rewards.keys():
		#l = Label.new()
		#l.text = "%s: %s" % [r.capitalize(), str(q.resource_rewards[r])]
		#resource_reward_container.add_child(l)
	for child in item_reward_container.get_children():
		child.queue_free()
	var slot_ui : ItemSlotUI
	for s in q.rewards.slots:
		slot_ui = ITEM_SLOT_UI.instantiate()
		slot_ui.set_slot_data(s)
		item_reward_container.add_child(slot_ui)
	if q.state != Quest.QuestState.COMPLETE:
		collect_rewards_button.hide()
	else:
		collect_rewards_button.show()

func open() -> void:
	_load_quests()
	show()

func close() -> void:
	displayed_quest = null
	hide()
