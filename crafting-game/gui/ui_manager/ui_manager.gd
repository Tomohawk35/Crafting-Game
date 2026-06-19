## UI_Manager
extends CanvasLayer

@export var player_hud : PlayerHUD
@export var tavern_panel : TavernPanel
@export var forge_panel : ForgePanel
@export var roster_panel: RosterPanel
@export var map_location_panel : MapLocationPanel
@export var quest_panel : QuestPanel

var ui_stack : Array[Control] = []

func _ready() -> void:
	EventBus.location_clicked.connect(_on_location_clicked)
	EventBus.building_clicked.connect(_on_building_clicked)
	tavern_panel.close()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"): # TODO: Add pause menu to exit game
		_close_all_windows()
	
	if event.is_action_pressed("roster"):
		if roster_panel.visible:
			roster_panel.close()
			ui_stack.erase(roster_panel)
		else:
			roster_panel.open()
			ui_stack.append(roster_panel)
	
	if event.is_action_pressed("quests"):
		if quest_panel.visible:
			quest_panel.close()
			ui_stack.erase(quest_panel)
		else:
			quest_panel.open()
			ui_stack.append(quest_panel)

func _close_all_windows() -> void:
	for c in range(ui_stack.size()):
		_close_window()

func _close_window() -> void:
	if ui_stack.back() and ui_stack.back().has_method("close"):
		ui_stack.pop_back().close()

func _on_building_clicked(b: Constants.Buildings) -> void: # TODO: 
	match b:
		Constants.Buildings.TAVERN:
			tavern_panel.open()
			ui_stack.append(tavern_panel)
		Constants.Buildings.FORGE:
			forge_panel.open()
			ui_stack.append(forge_panel)
		_:
			pass

func _on_location_clicked(l: Constants.Locations) -> void:
	if GameManager.locations.has(l):
		map_location_panel.set_location(l)
		map_location_panel.open()
		ui_stack.append(map_location_panel)
