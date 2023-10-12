extends Node

@export var timeBetweenTicks := 0.2
var ticks := 0
var activeSeed := 0: get = getSeed, set = changeSeed
var seedCount := 0
var plotsBought := 0
var seedsUnlocked := 1
var colorRandomizer := [0,0,0] #each out of 255
var inventoryUnlock := [0,0] #[upgrades bought, inv space]
var seedInventory := [] #[ [amount of seeds, worth of seeds] ... ]
var gameDataArray = ["ticks", "activeSeed", "seedCount", "plotsBought", "seedsUnlocked"]
var money := 50.0: get = getMoney, set = changeMoney
var marketBought := false
signal tickUpdate
signal moneyUpdate
signal seedUpdate
signal colorUpdate
signal invUpdate
signal sceneChange

func _ready():
	$Timer.wait_time = timeBetweenTicks
	upgradeInventory()
	pass

func getTicks():
	return ticks

func changeSeed(s: int):
	activeSeed = s

func getSeed():
	return activeSeed
	
func getSeeds():
	return seedCount

func boughtSeed(amount):
	seedCount += amount
	emit_signal("seedUpdate")

func seedUsed():
	if seedCount > 1:
		activeSeed = randi_range(1,seedsUnlocked)
		seedCount -= 1
	else:
		activeSeed = 0
		seedCount = 0
	emit_signal("seedUpdate")
	
func changeMoney(m: float):
	money += m
	emit_signal("moneyUpdate")
	
func getMoney():
	return money

func boughtPlot():
	plotsBought += 1
	
func addColors(color: int, amount: int):
	colorRandomizer[color] += amount
	emit_signal("colorUpdate")
	
func getColorer(col: int):
	return colorRandomizer[col]

func uSeeds():
	return seedsUnlocked

func unlockSeed():
	seedsUnlocked += 1
	
func nextPlotCost():
	if plotsBought != 0:
		return 30 + 30 * (plotsBought-1) * .25
	return 0;
	
func upgradeInventory():
	if inventoryUnlock[0] == 0:
		inventoryUnlock[0] = 1
		for i in range(9):
			seedInventory.append([0,0.0])
	else:
		inventoryUnlock[1] += 25
		inventoryUnlock[0] += 1
	
func updateInventory(p: int, v: float):
	seedInventory[p][0]+=1
	seedInventory[p][1]+=v
	emit_signal("invUpdate", p)
	
func resetInventory(p: int):
	seedInventory[p][0]=0
	changeMoney(seedInventory[p][1] * .01 * Market.prices[p])
	seedInventory[p][1]=0
	emit_signal("invUpdate", p)
	
func invCount():
	var sum = 0
	for i in range(seedInventory.size()):
		sum += seedInventory[i][0]
	return sum
	
func invFull():
	if invCount() >= inventoryUnlock[1]:
		return true
	return false
	
func _on_Timer_timeout():
	ticks += 1
	emit_signal("tickUpdate")

func sceneChanged(path: String):
	emit_signal("sceneChange", path)
	if path == "res://src/scenes/home.tscn":
		$Timer.paused = true
	else:
		$Timer.paused = false

func saveGameVars():
	var gameData = ""
	for i in gameDataArray:
		gameData += str(get(i)) + " "
	gameData += str(money) + " "
	for i in range(3):
		gameData += str(colorRandomizer[i]) + " "
	for i in range(2):
		gameData += str(inventoryUnlock[i]) + " "
	for i in seedInventory:
		gameData += str(i[0]) + " " + str(i[1]) + " "
	gameData += CropArray.saveArrayVars()
	return gameData
	
func saveGame():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line(saveGameVars())
	save_game.store_line(str(marketBought) + Market.saveMarket())

func loadGame():
	if not FileAccess.file_exists("user://savegame.save"):
		return
		
	changeMoney(-money)
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	var currLine = save_game.get_line()
	var currData = currLine.split(" ", false)
	var currPlace = 0
	
	for i in range(gameDataArray.size()):
		set(gameDataArray[i], int(currData[i]))
	currPlace = gameDataArray.size()
	
	money = float(currData[currPlace])
	currPlace += 1
	
	for i in range(3):
		colorRandomizer[i] = int(currData[currPlace + i])
	currPlace += 3
	
	for i in range(2):
		inventoryUnlock[i] = int(currData[currPlace + i])
	currPlace += 2
	
	for i in range(8):
		seedInventory[i][0] = int(currData[currPlace])
		currPlace += 1
		seedInventory[i][1] = int(currData[currPlace])
		currPlace += 1
		
	CropArray.loadArrData(save_game)
