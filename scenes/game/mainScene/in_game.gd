extends CanvasLayer


func _ready():
	GameManager.start_game()


func _on_game_over_pressed():
	GameManager.end_game()
	get_tree().change_scene_to_file("res://scenes/game/earningsScreen/earnings_screen.tscn")
