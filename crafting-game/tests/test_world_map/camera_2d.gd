extends Camera2D

## Zoom speed: multiplies [member Camera2D.zoom] each mouse wheel scroll (set to 1 to disable zooming).
@export_range(0.1, 10) var zoom_factor : float = 0.2
## Minimum [member Camera2D.zoom].
@export_range(0.01, 100) var zoom_min : float = 0.5
## Maximum [member Camera2D.zoom].
@export_range(0.01, 100) var zoom_max : float = 2.0
## If [code]true[/code], [member MapCamera2D.zoom_min] is effectively increased (up to [member MapCamera2D.zoom_max]) to stay within limits.
@export var zoom_limited : bool = true
## If [code]true[/code], mouse zooming is done relative to the cursor (instead of to the center of the screen).
@export var zoom_relative : bool = true
## If [code]true[/code], zooming can also be done with the plus and minus keys.
@export var zoom_keyboard : bool= true

@export var pan_speed : float = 1.0

### Pan speed: adds to [member Camera2D.offset] while the cursor is near the viewport's edges (set to 0 to disable panning).
#@export_range(0, 10000) var pan_speed := 250.0
### Maximum number of pixels away from the viewport's edges for the cursor to be considered near.
#@export_range(0, 1000) var pan_margin := 25.0
### If [code]true[/code], panning can also be done with the arrow keys (and space bar for centering).
#@export var pan_keyboard := true
### If [code]true[/code], the map can be dragged while holding the left mouse button.
#@export var drag := true
### Slide after dragging: multiplies the final drag movement each second (set to 0 to stop immediately).
#@export_range(0, 1) var drag_inertia := 0.1

var is_dragging : bool = false
var last_position : Vector2 = Vector2.ZERO
var drag_position : Vector2 = Vector2.ZERO





func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("select"):
		is_dragging = false
		last_position = Vector2.ZERO
	
	if event.is_action_pressed("zoom_in"):
		if zoom.x < zoom_max:
			zoom += Vector2(zoom_factor, zoom_factor)
	
	if event.is_action_pressed("zoom_out"):
		if zoom.x > zoom_min:
			zoom -= Vector2(zoom_factor, zoom_factor)
	
	if event.is_action_pressed("select"):
		if not is_dragging:
			is_dragging = true
			last_position = get_global_mouse_position()
	
	if event is InputEventMouseMotion and is_dragging:
		drag_position = get_global_mouse_position()
		if last_position != Vector2.ZERO:
			var difference : Vector2 = Vector2.ZERO
			difference.x = drag_position.x - last_position.x
			difference.y = drag_position.y - last_position.y
			#global_position -= (difference * pan_speed)
			global_position -= difference # TODO: Need to add smoothing due to pixel art
		last_position = drag_position
		
