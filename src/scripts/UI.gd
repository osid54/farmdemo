extends Control

func _ready():
	Autoload.connect("moneyUpdate", Callable(self, "moneyChange"))
	Autoload.connect("seedUpdate", Callable(self, "seedChange"))
	Autoload.connect("colorUpdate", Callable(self, "colorChange"))
	Autoload.connect("invUpdate", Callable(self, "updateInv"))
	moneyChange()
	seedChange()
	colorChange()
	$CanvasLayer/right/vBox/unlockButton.tooltip_text = str("$",Autoload.uSeeds()*750)
	$CanvasLayer/right/vBox/uLabel.text = "unlocked: "+str(Autoload.uSeeds())+"/8"
	if Autoload.inventoryUnlock[0] == 1:
		invVisible(false)
	else:
		$CanvasLayer/right/vBox/invLabel.text = "storage: " + str(Autoload.invCount()) + "/" + str(Autoload.inventoryUnlock[1])
	if Autoload.marketBought:
		$CanvasLayer/marketRect.visible = true
		$CanvasLayer/marketButton.visible = false
	else:
		$CanvasLayer/marketRect.visible = false
		$CanvasLayer/marketButton.visible = true

func moneyChange():
	$CanvasLayer/right/vBox/mLabel.text = "$" + "%.2f" % [Autoload.getMoney()]

func seedChange():
	$CanvasLayer/right/vBox/sLabel.text = "seeds: "+str(Autoload.getSeeds())

func colorChange():
	$CanvasLayer/right/vBox/HBoxContainer/rLabel.text = "c:\n"+str(Autoload.getColorer(0))+"/255"
	$CanvasLayer/right/vBox/rBox/rButton.tooltip_text = "$" + str(colorCost(0,1))
	$CanvasLayer/right/vBox/rBox/r5.tooltip_text = "$" + str(colorCost(0,5))
	$CanvasLayer/right/vBox/rBox/r10.tooltip_text = "$" + str(colorCost(0,10))
	
	$CanvasLayer/right/vBox/HBoxContainer/gLabel.text = "m:\n"+str(Autoload.getColorer(1))+"/255"
	$CanvasLayer/right/vBox/gBox/gButton.tooltip_text = "$" + str(colorCost(1,1))
	$CanvasLayer/right/vBox/gBox/g5.tooltip_text = "$" + str(colorCost(1,5))
	$CanvasLayer/right/vBox/gBox/g10.tooltip_text = "$" + str(colorCost(1,10))
	
	$CanvasLayer/right/vBox/HBoxContainer/bLabel.text = "y:\n"+str(Autoload.getColorer(2))+"/255"
	$CanvasLayer/right/vBox/bBox/bButton.tooltip_text = "$" + str(colorCost(2,1))
	$CanvasLayer/right/vBox/bBox/b5.tooltip_text = "$" + str(colorCost(2,5))
	$CanvasLayer/right/vBox/bBox/b10.tooltip_text = "$" + str(colorCost(2,10))
	
func seedBought(amount):
	if Autoload.getMoney() >= 5*amount:
		Autoload.changeMoney(-5*amount)
		Autoload.changeSeed(randi_range(1,Autoload.seedsUnlocked))
		Autoload.boughtSeed(amount)

func colorBought(color, amount):
	var cost = colorCost(color, amount)
	
	if Autoload.getMoney() >= cost:
		Autoload.changeMoney(-1 * cost)
		if Autoload.getColorer(color) + amount <= 255:
			Autoload.addColors(color, amount)
		
func unlockSeed():
	if Autoload.uSeeds() < 8:
		if Autoload.getMoney() >= Autoload.uSeeds()*750:
			Autoload.changeMoney(Autoload.uSeeds()*-750)
			Autoload.unlockSeed()
			$CanvasLayer/right/vBox/uLabel.text = "unlocked: "+str(Autoload.uSeeds())+"/8"
	$CanvasLayer/right/vBox/unlockButton.tooltip_text = str("$",Autoload.uSeeds()*750)

func allColors():
	for i in range(3):
		Autoload.colorRandomizer[i] = 255
		Autoload.addColors(i, 0)

func invBought():
	if Autoload.getMoney() >= 2500:
		Autoload.changeMoney(-2500)
		if Autoload.inventoryUnlock[0] == 1:
			invVisible(true)
		Autoload.upgradeInventory()
		$CanvasLayer/right/vBox/invLabel.text = "storage: " + str(Autoload.invCount()) + "/" + str(Autoload.inventoryUnlock[1])
	
func updateInv(_signalP):
	$CanvasLayer/right/vBox/invLabel.text = "storage: " + str(Autoload.invCount()) + "/" + str(Autoload.inventoryUnlock[1])
	
func invVisible(change: bool):
	$CanvasLayer/right/vBox/invRow1.visible = change
	$CanvasLayer/right/vBox/invRow2.visible = change
	$CanvasLayer/right/vBox/invLabel.visible = change
	if change:
		$CanvasLayer/right/vBox/invUpgrade.text = "upgrade storage (+25)"
	else:
		$CanvasLayer/right/vBox/invUpgrade.text = "unlock storage"

func colorCost(color: int, amount: int):
	var colorWorth = 5
	var cost = 0
	var totalCost = 0
	
	cost += Autoload.getColorer(color) * colorWorth
	
	for i in amount:
		cost += colorWorth
		totalCost += cost 
	
	return totalCost

func marketBuy():
	if Autoload.getMoney() >= 3000:
		Autoload.changeMoney(-3000)
		Autoload.marketBought = true
		$CanvasLayer/marketRect.visible = true
		$CanvasLayer/marketButton.visible = false
