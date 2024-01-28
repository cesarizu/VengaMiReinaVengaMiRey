extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#Son variables de prueba para verificar que esté funcionando
	#Luego conectamos las variables del GameManager
	var achieved = GameManager._achieved
	var tips = 10
	var incomes = achieved * GameManager.price + tips
	var failed = GameManager._failed
	var losses = failed*5
	var earnings = incomes - losses
	GameManager._money_current += earnings
	if earnings >= GameManager._highScore:
		$NuevoRecord.text = "NUEVO RECORD"	
		GameManager._highScore = earnings
	else:
		$NuevoRecord.text = ""
	$Cuentas/ConseguidosNum.text = str(achieved)
	$Cuentas/PrecioNum.text = str(GameManager.price) 
	$Cuentas/PropinasNum.text = str(tips) 
	$Cuentas/NoConseguidosNum.text = str(failed)
	$Cuentas/TotalNum.text = str(earnings)
	GameManager._achieved = 0 #Pedidos entregados
	GameManager._failed = 0 #Pedidos fallados

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
	pass # Replace with function body.
