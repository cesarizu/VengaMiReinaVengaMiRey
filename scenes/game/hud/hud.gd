extends CanvasLayer

const CallButton := preload("res://scenes/game/hud/call_button.tscn")

@onready var calls: VBoxContainer = %Calls


func _ready() -> void:
	var money_holder = 50
	$actual_earnings.text = str(money_holder)
	
	for info: CallInfo in GameManager.config.call_info:
		var button: Button = CallButton.instantiate()
		button.text = info.text
		button.pressed.connect(_on_button_pressed.bind(info))
		calls.add_child(button)


func _on_button_pressed(info: CallInfo):
	GameManager.call_client(info)
