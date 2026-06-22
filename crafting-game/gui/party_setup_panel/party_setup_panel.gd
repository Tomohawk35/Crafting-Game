extends Control
class_name PartySetupPanel

const PARTY_MEMBER_SELECT_PANEL : PackedScene = preload("uid://cy17x5fgp1kr2")

var selected_party : Party

# Party Select Panel
@onready var party_button_container: VBoxContainer = %PartyButtonContainer
@onready var add_party_button: Button = %AddPartyButton
# Party Info Panel
@onready var party_name_text_edit: TextEdit = %PartyNameTextEdit
@onready var party_member_button_container: VBoxContainer = %PartyMemberButtonContainer
@onready var remove_all_members_button: Button = %RemoveAllMembersButton
@onready var delete_party_button: Button = %DeletePartyButton

func _ready() -> void:
	add_party_button.pressed.connect(_on_add_party_button_pressed)
	delete_party_button.pressed.connect(_on_delete_party_button_pressed)
	remove_all_members_button.pressed.connect(_on_remove_all_members_button_pressed)

func _clear_party_info_panel() -> void:
	party_name_text_edit.text = "Select Party"
	for child in party_member_button_container.get_children():
		child.queue_free()

func _load_party_data() -> void:
	party_name_text_edit.text = selected_party.party_name
	for child in party_member_button_container.get_children():
		child.queue_free()
	var b : Button
	for i in range(selected_party.max_party_size):
		b = Button.new()
		if selected_party.members[i]:
			b.text = selected_party.members[i].hero_name
		else:
			b.text = "Select Hero"
		party_member_button_container.add_child(b)
		b.pressed.connect(_on_party_member_button_pressed.bind(i))

func _update_party_buttons() -> void:
	for child in party_button_container.get_children():
		child.queue_free()
	var b : Button
	for p : Party in HeroManager.parties:
		b = Button.new()
		b.text = p.party_name
		b.pressed.connect(_on_party_button_pressed.bind(p))
		party_button_container.add_child(b)

func _on_party_button_pressed(p: Party) -> void:
	selected_party = p
	_load_party_data()

func _on_add_party_button_pressed() -> void:
	HeroManager.create_party()
	_update_party_buttons()

func _on_party_member_button_pressed(index: int) -> void:
	var hero_select_panel : PartyMemberSelectPanel = PARTY_MEMBER_SELECT_PANEL.instantiate()
	hero_select_panel.hero_selected.connect(_on_hero_selected.bind(index))
	add_child(hero_select_panel)

func _on_delete_party_button_pressed() -> void:
	if !selected_party:
		return
	HeroManager.delete_party(selected_party)
	_update_party_buttons()
	_clear_party_info_panel()

func _on_remove_all_members_button_pressed() -> void:
	if !selected_party:
		return
	selected_party.remove_all_members()
	_load_party_data()

func _on_hero_selected(h: HeroData, index: int) -> void:
	if !h:
		print("No hero selected")
		return
	selected_party.add_member_at_index(h, index)
	party_member_button_container.get_children()[index].text = h.hero_name
