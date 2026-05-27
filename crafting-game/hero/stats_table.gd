extends Resource
class_name StatsTable

@export var stats: Dictionary = {
	"charisma": 0.0,
	"charisma_flat": 0.0,
	"charisma_pct": 0.0,
	"dexterity": 0.0,
	"dexterity_flat": 0.0,
	"dexterity_pct": 0.0,
	"intelligence": 0.0,
	"intelligence_flat": 0.0,
	"intelligence_pct": 0.0,
	"luck": 0.0,
	"luck_flat": 0.0,
	"luck_pct": 0.0,
	"quest_speed": 0.0,
	"quest_speed_flat": 0.0,
	"quest_speed_pct": 0.0,
	"strength": 0.0,
	"strength_flat": 0.0,
	"strength_pct": 0.0,
	"travel_speed": 0.0,
	"travel_speed_flat": 0.0,
	"travel_speed_pct": 0.0
}

func get_calculated_stat(stat: String, base_value : float = 0.0) -> float:
	return (base_value + stats[stat + "_flat"]) * (1.0 + stats[stat + "_pct"])
