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
	$Cuentas/Conseguidos.text = "Pedidos Conseguidos " + str(achieved)
	$Cuentas/Precio.text = "Precio " + str(price) 
	$Cuentas/Propinas.text = "Propinas " + str(tips) 
	$Cuentas/NoConseguidos.text = "No conseguidos " + str(failed)
	$Cuentas/Total.text = "TOTAL " + str(earnings)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
	pass # Replace with function body.
