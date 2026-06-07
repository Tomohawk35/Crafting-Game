extends Control
class_name RosterPanel



@onready var roster_container: VBoxContainer = %RosterContainer

func open() -> void:
	show()

func close() -> void:
	hide()
