extends BaseButton
class_name SwipeButton

@export var _debug_visibility: bool = false:
	set = set_debug_visibility
	
var _debug_color: = Color(0, 1, 0, .8)
var _debug_backcolor: = Color(0, 1, 0, .5)
var _debug_line_color: = Color(255,0,0)

@export var limit: = Vector2.ZERO
var _limit_broke: = false
signal limit_exceeded

var _click_offset: = Vector2.ZERO
var _click_position: = Vector2.ZERO
var swipe_offset: = Vector2.ZERO

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), _debug_backcolor)
	draw_rect(Rect2(Vector2.ZERO, size), _debug_color, false, 3)
	
	draw_line(_click_offset,_click_offset + swipe_offset, _debug_line_color, 3)

	draw_rect(Rect2(_click_offset-limit, limit*2), _debug_line_color, false, 1)

	
func _init():
	set_debug_visibility(_debug_visibility)
	action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
	keep_pressed_outside = true
	button_down.connect(update_click_offset)

func _physics_process(delta: float) -> void:
	if button_pressed:
		swipe_offset = get_global_mouse_position() - _click_position

		queue_redraw()
		if limit > Vector2.ZERO:
			if abs(swipe_offset.x) > limit.x or abs(swipe_offset.y) > limit.y:
				if not _limit_broke:
					button_pressed = false
					button_up.emit()
					limit_exceeded.emit(abs(swipe_offset) + _click_offset)
					_limit_broke = true

func set_debug_visibility(value):
	_debug_visibility = value
	_debug_color.a = float(value)
	_debug_backcolor.a = float(value) / 1.4
	_debug_line_color.a = float(value)
	queue_redraw()

func update_click_offset():
	_click_offset = get_global_mouse_position() - global_position
	_click_position = get_global_mouse_position()
	_limit_broke = false
