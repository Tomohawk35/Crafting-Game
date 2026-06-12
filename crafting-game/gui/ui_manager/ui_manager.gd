## UI_Manager
extends CanvasLayer


@export var player_hud : PlayerHUD
@export var tavern_panel : TavernPanel
@export var forge_panel : ForgePanel
@export var roster_panel: RosterPanel
@export var map_location_panel : MapLocationPanel

var ui_stack : Array[Control] = []



func _ready() -> void:
	EventBus.location_clicked.connect(_on_location_clicked)
	#EventBus.tavern_clicked.connect(_on_tavern_clicked)
	EventBus.building_clicked.connect(_on_building_clicked)
	tavern_panel.close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		_close_window()
	if event.is_action_pressed("roster"):
		roster_panel.open()
		ui_stack.append(roster_panel)

func _close_all_windows() -> void:
	for c in range(ui_stack.size()):
		_close_window()

func _close_window() -> void:
	if ui_stack[-1].has_method("close"):
		ui_stack[-1].close()

func _on_building_clicked(b: String) -> void: # TODO: Update to use constants instead
	print("Building clicked: ", b)
	match b:
		"tavern":
			tavern_panel.open()
			ui_stack.append(tavern_panel)
		"blacksmith":
			forge_panel.open()
			ui_stack.append(forge_panel)


func _on_location_clicked(l: String) -> void:
	#print("Location clicked")
	if GameManager.locations.has(l):
		map_location_panel.set_location(l)
		map_location_panel.open()
		ui_stack.append(map_location_panel)

#func _on_tavern_clicked() -> void:
	#tavern_panel.open()
	#ui_stack.append(map_location_panel)
