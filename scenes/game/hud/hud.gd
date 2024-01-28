extends CanvasLayer

const CallButton := preload("res://scenes/game/hud/call_button.tscn")
var money = GameManager._money_current

@onready var calls: VBoxContainer = %Calls

func _ready() -> void:
	#GameManager.on_money_updated.connect(_on_money_updated)
	$actual_earnings.text = str(money)
	for info: CallInfo in GameManager.config.call_info:
		var button: Button = CallButton.instantiate()
		button.text = info.text
		button.pressed.connect(_on_button_pressed.bind(info))
		calls.add_child(button)


func _on_button_pressed(info: CallInfo):
	GameManager.call_client(info)

func _on_add_pressed():
	print("Añadiste")
	money = money + GameManager.price
	GameManager._achieved += 1
	print(money)
	$actual_earnings.text = str(money)

func _on_loss_pressed():
	print("Quitaste")
	money = money - GameManager.price
	GameManager._failed += 1
	print(str(money))
	$actual_earnings.text = str(money)
