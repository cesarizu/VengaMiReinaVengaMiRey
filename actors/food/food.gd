class_name Food
extends RigidBody2D

@export var simlation_step_time := 0.25
@export var throw_speed_multiplier := 3

@onready var hold: Sprite2D = %Hold
@onready var direction: Line2D = %Direction

var food_info: FoodInfo

var _holding := false
var _throw_velocity := Vector2.ZERO
var _throw_force := Vector2.ZERO


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		_holding = event.pressed
		_update_hold()


func _physics_process(delta: float) -> void:
	if _holding:
		_update_hold_and_direction()

	if _throw_force != Vector2.ZERO:
		apply_central_impulse(-_throw_force)
		_throw_force = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not _holding:
		return
	
	if event is InputEventMouseButton:
		_holding = event.pressed
		_update_hold()


func _update_hold():
	hold.visible = _holding
	direction.visible = _holding

	if not _holding:
		freeze = false
		_throw_force = -_throw_velocity

		
func _update_hold_and_direction():
		var dest := to_local(get_viewport().get_mouse_position())
		var distance := dest.length()
		var angle := dest.angle()

		hold.region_rect.size.x = distance
		hold.rotation = angle

		_throw_velocity = -dest.normalized() * clamp(distance, 0, 500) * throw_speed_multiplier

		var vel: Vector2 = _throw_velocity
		var pos := Vector2.ZERO
		for a in direction.points.size():
			direction.points[a] = pos
			vel += Vector2.DOWN * 980 * simlation_step_time
			pos += vel * simlation_step_time
