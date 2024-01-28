class_name Client
extends Node2D

var client_info: ClientInfo
var tween: Tween

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var bubble: Sprite2D = %Bubble
@onready var food: Sprite2D = %Food
@onready var progress: TextureProgressBar = %TextureProgressBar
@onready var area: Area2D = %Area2D
@onready var happy_hearts: AnimatedSprite2D = %HappyHearts
@onready var splash: AnimatedSprite2D = %Splash

var food_info: FoodInfo

var _patience_time := 0.0
var _patience_time_left := 0.0


func _ready() -> void:
	happy_hearts.hide()
	splash.hide()
	bubble.hide()


func _process(delta: float) -> void:
	if not bubble.visible: return
	
	if _patience_time_left > 0:
		_patience_time_left -= delta
		progress.value = 1 - _patience_time_left / _patience_time
	elif _patience_time > 0:
		GameManager.notify_client_patience_ended(self)
		_patience_time = 0


func approach(food_info_: FoodInfo):
	food_info = food_info_
	z_index = GameManager._lastZ#IO

	walk_happy_to(position + Vector2.DOWN * 100)
	await tween.finished
	
	animation_player.play(&"waiting")

	food.texture = food_info.texture
	GameManager._lastZ = GameManager._lastZ -1#IO
	bubble.show()

	_patience_time = randf_range(15, 25)
	_patience_time_left = randf_range(15, 25)


func walk_happy_to(new_position: Vector2, very_happy := false):
	happy_hearts.visible = very_happy
	animation_player.play(&"walking_happy")
	move_to(new_position)


func walk_away_sad_to(new_position: Vector2):
	animation_player.play(&"walking_sad")
	move_to(new_position)


func move_to(new_position: Vector2):
	if tween:
		tween.kill()
		tween = null

	scale = Vector2(-1 if new_position.x > position.x else 1, 1)

	var distance := position.distance_to(new_position)

	tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, 0.005 * distance / client_info.speed_multiplier)


func _on_area_2d_body_shape_entered(body_rid: RID, food: Food, body_shape_index: int, local_shape_index: int) -> void:
	if not food:
		return

	var shape := area.shape_owner_get_owner(local_shape_index)
	var is_good: bool = food.food_info == food_info
	
	bubble.hide()

	if is_good:
		GameManager.notify_food_hit(self, food.food_info)
	else:
		splash.show()
		splash.play()
		GameManager.notify_client_patience_ended(self)
	
	food.queue_free()
