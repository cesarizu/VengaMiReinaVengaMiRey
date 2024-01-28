extends Node

signal on_money_updated(money)
signal spawn_client(client_info)
signal spawn_food(food_info)
signal food_thrown(food)
signal food_hit(client, food_info, good)
signal game_started
signal game_ended


var config: GameConfig = preload("res://config/game_config.tres")

var price := 10
var _achieved = 0 #Pedidos entregados
var _failed = 0 #Pedidos fallados
var _highScore = 0

var _money_current := 50:
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
	_food_timer.timeout.connect(_on_food_timer_timeout)
	add_child(_food_timer)


func start_game():
	_money_current = config.initial_money
	_client_timer.start()
	_food_timer.start()
	game_started.emit()


func end_game():
	_client_timer.stop()
	_food_timer.stop()
	game_ended.emit()


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
	_passing_clients.erase(client)
	_waiting_clients.push_back(client)
	_update_waiting_client_z_indexes()


func client_left(client: Client):
	_passing_clients.erase(client)
	_waiting_clients.erase(client)
	_update_waiting_client_z_indexes()


func notify_food_thrown(food: Food):
	_current_food_count -= 1
	food_thrown.emit(food)


func notify_food_hit(client: Client, food_info: FoodInfo, good: bool):
	if good:
		_money_current += food_info.eat_profit
	food_hit.emit(client, food_info, good)


func _update_waiting_client_z_indexes():
	for a in _waiting_clients.size():
		_waiting_clients[a].z_index = -a


func _on_client_timer_timeout():
	if _passing_clients.size() < config.client_spawn_max:
		spawn_client.emit(config.client_info.pick_random())


func _on_food_timer_timeout():
	if _current_food_count < config.food_spawn_max:
		spawn_food.emit(config.food_info.pick_random())
		_current_food_count += 1
