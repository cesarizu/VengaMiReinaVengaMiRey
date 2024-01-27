extends Node

signal on_money_updated(money)
signal spawn_client(client_info)
signal spawn_food(food_info)

var config: GameConfig = preload("res://config/game_config.tres")

var _money_current := 10:
	set(value):
		_money_current = value
		on_money_updated.emit(value)


var _client_timer: Timer
var _food_timer: Timer

var _current_food_count := 0
var _passing_clients: Array[Client] = []
var _waiting_clients: Array[Client] = []


func _ready() -> void:
	_client_timer = Timer.new()
	_client_timer.autostart = false
	_client_timer.wait_time = config.client_spawn_interval
	_client_timer.timeout.connect(_on_client_timer_timeout)
	add_child(_client_timer)
	
	_food_timer = Timer.new()
	_food_timer.autostart = false
	_food_timer.wait_time = config.food_spawn_interval
	_food_timer.timeout.connect(_on_client_timer_timeout)
	add_child(_food_timer)


func start_game():
	_money_current = config.initial_money
	_client_timer.start()
	_food_timer.start()


func end_game():
	_client_timer.stop()
	_food_timer.stop()


func client_spawned(client: Client):
	_passing_clients.append(client)


func call_client(call_info: CallInfo) -> bool:
	if _passing_clients.is_empty():
		return false

	# TODO solo llamar a los que corresponde (e.g. "Mi rey" que llame solo a señores)
	_passing_clients.shuffle()
	_passing_clients.pop_back().approach(config.food_info.pick_random())
	return true


func client_approaching(client: Client):
	_waiting_clients.push_back(client)
	_update_waiting_client_z_indexes()


func food_thrown(food_info: FoodInfo, good: bool):
	if good:
		_money_current += food_info.eat_profit


func _on_client_timer_timeout():
	if _passing_clients.size() < config.client_spawn_max:
		spawn_client.emit(config.client_info.pick_random())


func _on_food_timer_timeout():
	if _current_food_count < config.food_spawn_max:
		spawn_food.emit(config.food_info.pick_random())


func _update_waiting_client_z_indexes():
	for a in _waiting_clients.size():
		_waiting_clients[a].z_index = -a
