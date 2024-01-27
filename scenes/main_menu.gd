extends CanvasLayer

const Game := preload("res://scenes/game.tscn")
const Credits := preload("res://scenes/credits.tscn")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(Game)


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(Credits)
