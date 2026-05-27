## Global - TimeManager
extends Node

signal new_day(d: int)
signal tick(h: int, m: int)

const _FRAME_TO_TICK_RATE : int = 50

var day : int = 1
var hour : int = 0
var minute : int = 0

var clock_on : bool = false
var _frames_processed : int = 0

func _process(_delta: float) -> void:
	if !clock_on:
		return
	_frames_processed += 1
	if _frames_processed >= _FRAME_TO_TICK_RATE:
		_time_tick()
		_frames_processed = 0

func set_clock(d: int, h: int, m: int) -> void:
	day = d
	hour = h
	minute = m
	_frames_processed = 0

func start() -> void:
	clock_on = true

func stop() -> void:
	clock_on = false

func _time_tick() -> void:
	minute += 1
	if minute >= 60:
		hour += 1
		minute = 0
		if hour >= 24:
			day += 1
			hour = 0
			new_day.emit(day)
	tick.emit(hour, minute)

func get_formatted_time() -> String:
	return "%02d:%02d %s" % [hour % 12, floori(float(minute) / 10) * 10, "AM" if hour < 12 else "PM"]

func to_dict() -> Dictionary:
	var d : Dictionary = {}
	d["day"] = day
	d["hour"] = hour
	d["minute"] = minute
	return d

func from_dict(d: Dictionary) -> void:
	set_clock(d["day"], d["hour"], d["minute"])
