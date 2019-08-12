extends Camera2D

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

func _ready():
    set_process(true)

func _process(delta):
    if _timer == 0:
        return
    _last_shook_timer = _last_shook_timer + delta
    while _last_shook_timer >= _period_in_ms:
        _last_shook_timer = _last_shook_timer - _period_in_ms
        var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
        var new_x = rand_range(-1.0, 1.0)
        var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
        var new_y = rand_range(-1.0, 1.0)
        var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
        _previous_x = new_x
        _previous_y = new_y
        var new_offset = Vector2(x_component, y_component)
        set_offset(get_offset() - _last_offset + new_offset)
        _last_offset = new_offset
    _timer = _timer - delta
    if _timer <= 0:
        _timer = 0
        set_offset(get_offset() - _last_offset)

func shake(duration, frequency, amplitude):
    _duration = duration
    _timer = duration
    _period_in_ms = 1.0 / frequency
    _amplitude = amplitude
    _previous_x = rand_range(-1.0, 1.0)
    _previous_y = rand_range(-1.0, 1.0)
    set_offset(get_offset() - _last_offset)
    _last_offset = Vector2(0, 0)

const CAMERA_SPEED = 10.0
var target_pos
var loc
var mouse
var cap = 200
#func _process(delta):
#	loc = get_parent().get_node("Sprite").global_position
#	mouse = get_local_mouse_position()
#	target_pos = (loc + mouse) * 0.25
#	target_pos = target_pos.clamped(cap)
#	position = (position.linear_interpolate(target_pos, CAMERA_SPEED * delta))