extends Node2D

var bought := false
var plant := preload("res://src/actors/crop.tscn")
var pos := Vector2(-1,-1)
var crop

func _ready():
	$frame.visible = false 

func buy():
	$frame.visible = true
	bought = true
	Autoload.boughtPlot()

func checkBought():
	return bought
	
func plantSeed():
	if Autoload.getSeed() != 0:
		var p = plant.instantiate()
		add_child(p)
		p.plantType = Autoload.getSeed()
		p.position += Vector2(128,128)
		crop = p
		Autoload.seedUsed()

func butBought():
	if pos == Vector2(4,4):
		pass
	elif get_parent().checkNeighbors(pos):
		if Autoload.getMoney() >= Autoload.nextPlotCost():
			Autoload.changeMoney(-1*Autoload.nextPlotCost())
		else:
			return
	else:
		return
	buy()
	$buyButton.visible = false
	$plantButton.visible = true

func butPlant():
	if Autoload.getSeed() != 0:
		plantSeed()
		$plantButton.visible = false

func mouseEntered():
	if get_parent().checkNeighbors(pos):
		$buyButton.text = "$"+str(Autoload.nextPlotCost())
		if Autoload.nextPlotCost() != int(Autoload.nextPlotCost()):
			$buyButton.text = "$"+ "%.2f" % [Autoload.nextPlotCost()]

func mouseExit():
	if get_parent().checkNeighbors(pos):
		$buyButton.text = ""

func saveBoxVars():
	var boxData = str(bought) + " "
	if bought:
		boxData += str(pos.x) + " " + str(pos.y) + " "
		if crop and !$plantButton.visible:
			boxData += crop.saveCropVars()
	return boxData

func loadBoxData(lineData):
	$frame.visible = false
	$buyButton.visible = true
	bought = false
	
	for child in get_children():
		if child.is_in_group("crop"):
			child.queue_free()
			
	bought = lineData[0] == "true"
	
	if bought:
		$frame.visible = true
		if get_node_or_null("buyButton") != null:
			$buyButton.visible = false
		$plantButton.visible = true
		
		if lineData.size() > 3:
			$plantButton.visible = false
			
			var p = plant.instantiate()
			p.position += Vector2(128,128)
			crop = p
			
			crop.loadCropData(lineData)
			add_child(crop)
	
