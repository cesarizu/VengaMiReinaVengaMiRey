class_name Food
extends RigidBody2D

signal thrown

@export var simlation_step_time := 0.25
@export var throw_speed_multiplier := 3

@onready var _hold: Sprite2D = %Hold
@onready var _direction: Line2D = %Direction

var food_info: FoodInfo

var _holding := false
var _hold_dest := Vector2.ZERO
var _throw_velocity := Vector2.ZERO
var _throw_force := Vector2.ZERO


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		_holding = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_hold_dest = Vector2(100, 300)
		_update_hold()


func _physics_process(delta: float) -> void:
	if _holding:
		_update_hold_and_direction()

	if _throw_force != Vector2.ZERO:
		_throw()


func _input(event: InputEvent) -> void:
	if not _holding:
		return
	
	if event is InputEventMouseMotion:
		_hold_dest += event.relative
		_hold_dest = _hold_dest.limit_length(500)
		print(_hold_dest)
	
	if event is InputEventMouseButton:
		_holding = event.pressed
		_update_hold()


func _update_hold():
	_hold.visible = _holding
	_direction.visible = _holding

	if not _holding:
		_throw_force = -_throw_velocity

		
func _update_hold_and_direction():
		var distance := _hold_dest.length()
		var angle := _hold_dest.angle()

		_hold.region_rect.size.x = distance
		_hold.rotation = angle

		_throw_velocity = -_hold_dest.normalized() * clamp(distance, 0, 500) * throw_speed_multiplier

		var vel: Vector2 = _throw_velocity
		var pos := Vector2.ZERO
		for a in _direction.points.size():
			_direction.points[a] = pos
			vel += Vector2.DOWN * 980 * simlation_step_time
			pos += vel * simlation_step_time


func _throw():
	_holding = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	freeze = false
	apply_central_impulse(-_throw_force)
	_throw_force = Vector2.ZERO
	z_index = 3

	GameManager.notify_food_thrown(self)
	thrown.emit()
