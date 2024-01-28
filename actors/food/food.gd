class_name Food
extends RigidBody2D

signal thrown

@export var simlation_step_time := 0.25
@export var throw_speed_multiplier := 3

@onready var _hold: Sprite2D = %Hold
@onready var _direction: Line2D = %Direction
@onready var _original_collision_layer := collision_layer

var food_info: FoodInfo

var can_collide_sad := false

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
		_throw()

	if not freeze:
		if position.y < 550:
			# La comida subió lo suficiente para estar detras de la banda transportadora
			z_index = 0
		elif z_index <= 0:
			# La comida cayó lo suficiente y no debe colisionar mas
			collision_mask = 0


func _input(event: InputEvent) -> void:
	if not _holding:
		return
	
	if event is InputEventMouseButton:
		_holding = event.pressed
		_update_hold()


func _update_hold():
	_hold.visible = _holding
	_direction.visible = _holding

	if not _holding:
		_throw_force = -_throw_velocity

		
func _update_hold_and_direction():
		var dest := to_local(get_viewport().get_mouse_position())
		var distance := dest.length()
		var angle := dest.angle()

		_hold.region_rect.size.x = distance
		_hold.rotation = angle

		_throw_velocity = -dest.normalized() * clamp(distance, 0, 500) * throw_speed_multiplier

		var vel: Vector2 = _throw_velocity
		var pos := Vector2.ZERO
		for a in _direction.points.size():
			_direction.points[a] = pos
			vel += Vector2.DOWN * 980 * simlation_step_time
			pos += vel * simlation_step_time

func _throw():
	freeze = false
	apply_central_impulse(-_throw_force)
	_throw_force = Vector2.ZERO
	z_index = 3

	GameManager.notify_food_thrown(self)
	thrown.emit()

	collision_layer = 0
	await get_tree().create_timer(0.5).timeout
	collision_layer = _original_collision_layer
	await get_tree().create_timer(0.5).timeout
	can_collide_sad = true
