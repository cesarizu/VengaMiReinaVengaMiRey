extends Node

signal spawn_client(client_info)
signal spawn_food(food_info)
signal food_thrown(food)
signal food_hit(client, food_info, good)
signal client_patience_ended(client)
signal game_started
signal money_updated(money)
signal game_ended


var config: GameConfig = preload("res://config/game_config.tres")

var price := 10
var _achieved = 0 #Pedidos entregados
var _failed = 0 #Pedidos fallados
var _highScore = 0
var _lastZ = -1 #Última profundidad

var _money_current := 50:
	set(value):
		_money_current = value
		money_updated.emit(value)


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
	money_updated.emit(_money_current)


func end_game():
	_client_timer.stop()
	_food_timer.stop()
	game_ended.emit()


func client_spawned(client: Client):
	_passing_clients.append(client)


func call_client(call_info: CallInfo) -> bool:
	# TODO solo llamar a los que corresponde (e.g. "Mi rey" que llame solo a señores)
	var visible_clients := _passing_clients.filter(func(c): return c.position.x > 150 and c.position.x < 1400)

	if visible_clients.is_empty():
		return false

	visible_clients.shuffle()

	var selected: Client = visible_clients.pop_back()
	selected.approach(config.food_info.pick_random())
	_passing_clients.erase(selected)
	
	_update_waiting_client_z_indexes()

	return true


func client_approaching(client: Client):
	_passing_clients.erase(client)
	_waiting_clients.push_back(client)
	_update_waiting_client_z_indexes()


func client_left(client: Client):
	_passing_clients.erase(client)
	_waiting_clients.erase(client)
	_update_waiting_client_z_indexes()
	client.queue_free()


func notify_client_patience_ended(client: Client):
	_waiting_clients.erase(client)
	_update_waiting_client_z_indexes()
	client_patience_ended.emit(client)


func notify_food_thrown(food: Food):
	_current_food_count -= 1
	food_thrown.emit(food)


func notify_food_hit(client: Client, food_info: FoodInfo):
	var good := food_info == client.food_info

	if good:
		_money_current += food_info.eat_profit * 2
	else:
		_money_current += food_info.eat_profit

	food_hit.emit(client, food_info, good)
	
	_waiting_clients.erase(client)
	client.z_index = -49


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
