extends Node

var config: GameConfig = preload("res://config/game_config.tres")

var money_current := 0

func start_game():
	money_current = config.initial_money

