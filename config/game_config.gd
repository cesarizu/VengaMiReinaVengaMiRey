class_name GameConfig
extends Resource

@export var initial_money := 10

@export_group("Food", "food_")
@export var food_spawn_interval: float = 5.0
@export var food_spawn_max: int = 5
@export var food_info: Array[FoodInfo] = []

@export_group("Clients", "client_")
@export var client_spawn_max: int = 8
@export var client_info: Array[ClientInfo] = []

@export_group("Calls", "call_")
@export var call_info: Array[CallInfo] = []
