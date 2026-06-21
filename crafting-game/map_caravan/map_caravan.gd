extends PathFollow2D
class_name MapCaravan

# can update progress and progress_ratio
# probably use progress

# questing_speed and travel_speed

var expedition : Expedition

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clickable_area: ClickableAreaComponent = %ClickableArea

func _ready() -> void:
	if !expedition:
		print("Caravan does not have a valid expedition.")
		return # TODO: Queue free here
	_update_position()
	clickable_area.clicked.connect(_on_clicked)
	clickable_area.hovered.connect(_on_hover)
	clickable_area.unhovered.connect(_on_unhover)

func _process(_delta: float) -> void:
	if !expedition:
		return # TODO: Queue free
	_update_position()

func _on_clicked() -> void:
	pass

func _on_hover() -> void:
	pass

func _on_unhover() -> void:
	pass

func _update_position() -> void:
	match expedition.state:
		Expedition.States.TRAVELING:
			progress = expedition.progress
			animation_player.play("move_side")
			pass # TODO: Animate the caravan and update its position
		Expedition.States.IN_PROGRESS:
			progress_ratio = 1.0 # TODO: Idle animation
			animation_player.play("idle_down")
		Expedition.States.RETURNING:
			progress = expedition.progress
			animation_player.play("move_side")
		Expedition.States.COMPLETE:
			queue_free()
		_:
			pass

func set_expedition(e: Expedition) -> void:
	expedition = e
