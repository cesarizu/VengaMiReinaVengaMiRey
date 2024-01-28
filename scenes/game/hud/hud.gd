extends CanvasLayer

const CallButton := preload("res://scenes/game/hud/call_button.tscn")

@onready var calls: VBoxContainer = %Calls
@onready var money: Label = %Money


func _ready() -> void:
	GameManager.money_updated.connect(_on_money_updated)

	for info: CallInfo in GameManager.config.call_info:
		var button: Button = CallButton.instantiate()
		button.text = info.text
		button.pressed.connect(_on_button_pressed.bind(info))
		calls.add_child(button)


func _on_money_updated(value: int):
	money.text = str(value)


func _on_button_pressed(info: CallInfo):
	GameManager.call_client(info)

