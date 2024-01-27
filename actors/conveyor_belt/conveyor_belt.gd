extends Node2D

@export var positions: Array[Marker2D] = []

@onready var spawn_point: Marker2D = %Marker2DSpawn

var _food_amount := 0


func _ready() -> void:
	GameManager.spawn_food.connect(_on_spawn_food)
	
	
func _on_spawn_food(food_info: FoodInfo):
	if _food_amount > positions.size(): return
	
	var food: Food = food_info.spawn_scene.instantiate()
	food.food_info = food_info
	food.position = spawn_point.position
	food.z_index = 2
	add_child(food)

	food.move_to(positions[_food_amount].position)
	
	_food_amount += 1
