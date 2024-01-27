extends Node2D

const speed := 256.0

const Tray := preload("res://actors/conveyor_belt/Bandeja.png")

@export var positions: Array[Marker2D] = []

@onready var spawn_point: Marker2D = %Marker2DSpawn

var _trays: Array[Node2D] = []


func _ready() -> void:
	GameManager.spawn_food.connect(_on_spawn_food)
	
	
func _on_spawn_food(food_info: FoodInfo):
	if _trays.size() >= positions.size(): return

	var tray := Sprite2D.new()
	tray.texture = Tray
	tray.position = spawn_point.position
	tray.z_index = 2
	add_child(tray)
	
	var food: Food = food_info.spawn_scene.instantiate()
	food.food_info = food_info
	tray.add_child(food)
	
	move_to(tray, positions[_trays.size()].position)

	_trays.push_back(tray)


func move_to(tray: Node2D, new_position: Vector2):
	var tween := get_tree().create_tween()
	var time := tray.position.distance_to(new_position) / speed
	tween.tween_property(tray, "position", new_position, time)
