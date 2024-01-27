extends CanvasLayer

const left := Vector2(-200, 500)
const right := Vector2(1920 + 200, 500)


func _ready():
	GameManager.spawn_client.connect(_on_spawn_client)
	GameManager.food_thrown.connect(_on_food_thrown)
	GameManager.start_game()


func _on_game_over_pressed():
	GameManager.end_game()
	get_tree().change_scene_to_file("res://scenes/game/earningsScreen/earnings_screen.tscn")


func _on_spawn_client(client_info: ClientInfo):
	var face_left := randf() > 0.5
	var spawn_position := left if face_left else right

	var client: Client = client_info.spawn_scene.instantiate()
	client.client_info = client_info
	client.position = spawn_position
	client.z_index = -50
	add_child(client)
	
	client.move_to(right if face_left else left, )

	GameManager.client_spawned(client)
	await client.tween.finished
	GameManager.client_left(client)
	client.queue_free()


func _on_food_thrown(food: Food):
	pass
