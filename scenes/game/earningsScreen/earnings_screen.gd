extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#Son variables de prueba para verificar que esté funcionando
	#Luego conectamos las variables del GameManager
	var achieved = 2
	var price = 10 
	var tips = 10
	var incomes = achieved * price + tips
	var failed = 5
	var losses = price*5
	var earnings = incomes - losses
	$Cuentas/ConseguidosNum.text = str(achieved)
	$Cuentas/PrecioNum.text = str(price) 
	$Cuentas/PropinasNum.text = str(tips) 
	$Cuentas/NoConseguidosNum.text = str(failed)
	$Cuentas/TotalNum.text = str(earnings)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
	pass # Replace with function body.
