extends Node
@onready var musica_menu: AudioStreamPlayer = %MusicaMenu
@onready var musica_juego: AudioStreamPlayer = %MusicaJuego

func _ready():
	musica_menu.play()
	GameManager.game_started.connect(_on_game_started)
	
func _on_game_started():
	musica_menu.stop()
	musica_juego.play()
