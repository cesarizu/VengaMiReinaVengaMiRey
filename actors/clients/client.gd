class_name Client
extends Node2D

var client_info: ClientInfo
var tween: Tween

@onready var food: Sprite2D = %Food


func approach(food_info: FoodInfo):
	z_index = -1

	move_to(position + Vector2.DOWN * 100)

	food.texture = food_info.texture
	food.show()


func move_to(new_position: Vector2):
	if tween:
		tween.kill()
		tween = null

	var distance := position.distance_to(new_position)

	tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, 0.005 * distance / client_info.speed_multiplier)
