class_name Client
extends Node2D

var client_info: ClientInfo
var tween: Tween

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var food: Sprite2D = %Food


func approach(food_info: FoodInfo):
	z_index = -1

	walk_happy_to(position + Vector2.DOWN * 100)
	await tween.finished
	
	animation_player.play(&"waiting")

	food.texture = food_info.texture
	food.show()


func walk_happy_to(new_position: Vector2):
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
