extends Area2D
class_name ClickableAreaComponent

signal hovered
signal unhovered
signal clicked

var is_clickable : bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered_area_2d)
	mouse_exited.connect(_on_mouse_exited_area_2d)

func _on_mouse_entered_area_2d() -> void:
	is_clickable = true
	hovered.emit()

func _on_mouse_exited_area_2d() -> void:
	is_clickable = false
	unhovered.emit()

func _input(event: InputEvent) -> void: # TODO: Change to unhandled input?
	if event.is_action_pressed("select") and is_clickable:
		print("Area clicked")
		clicked.emit()
		get_tree().root.set_input_as_handled()
