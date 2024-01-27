extends CanvasLayer

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/game/mainScene/in_game.tscn")
	pass # Replace with function body.

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/options/optionsMenu.tscn")
	pass # Replace with function body.


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/credits/credits_screen.tscn")
	pass # Replace with function body.


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/titleScreen/titleScreen.tscn")
	pass # Replace with function body.
