## GLOBAL - ExpeditionManager
extends Node

signal expedition_started(e: Expedition)

var expeditions : Array[Expedition]

func _ready() -> void:
	TimeManager.tick.connect(_on_time_tick)

func _on_time_tick(_h: int, _m: int) -> void:
	_advance_expeditions()

func _advance_expeditions() -> void:
	for e: Expedition in expeditions:
		e.advance()

func start_expedition(e: Expedition) -> void:
	expedition_started.emit(e)
