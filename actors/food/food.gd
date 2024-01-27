class_name Food
extends Node2D

const speed := 256.0

var food_info: FoodInfo


func move_to(new_position: Vector2):
	var tween := get_tree().create_tween()
	var time := position.distance_to(new_position) / speed
	tween.tween_property(self, "position", new_position, time)
