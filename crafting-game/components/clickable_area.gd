extends Area2D
class_name ClickableAreaComponent

signal clicked

var is_clickable : bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered_area_2d)
	mouse_exited.connect(_on_mouse_exited_area_2d)

func _on_mouse_entered_area_2d() -> void:
	is_clickable = true

func _on_mouse_exited_area_2d() -> void:
	is_clickable = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and is_clickable:
		print("Area clicked")
		clicked.emit()
		get_tree().root.set_input_as_handled()
