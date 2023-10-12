extends Node2D

@export var plantType : int

var growthValue := 1.0
var life := 0
var birth := -1
var value := 0.0
var harvestable := false
var color := [0,0,0]
var plantDataArray = ["plantType", "growthValue", "life", "birth", "value"]
var loaded := false

@onready var crop = $cropSprite

func _ready():
	birth = Autoload.getTicks()
	Autoload.connect("tickUpdate", Callable(self, "tickUpdated"))
	Market.marketChange.connect(onMarketChange)
	color = [int(randf_range(255-Autoload.getColorer(0),255)), int(randf_range(255-Autoload.getColorer(1),255)), int(randf_range(255-Autoload.getColorer(2),255))]
	if !loaded:
		$cropSprite.modulate = Color8(color[0], color[1], color[2])
	$growthParticles.modulate = $cropSprite.modulate

func onMarketChange():
	if Autoload.marketBought:
		$Button.tooltip_text = str("sell for $", value*.01*Market.prices[plantType-1])

func tickUpdated():
	life+=1
	if !harvestable:
		if growthValue == 1.0:
			growthValue += plantType
			value = growthValue
		if $cropSprite.get_frame() < 4:
			crop.scale += Vector2(.1,.1)
			if life % 5 == 0:
				grow()
		else:
			harvestable = true
			applyColorValue()
			if !$Button.visible:
				$Button.visible = true
			$AnimationPlayer.play("done")

func grow():
	crop.scale = Vector2(1,1)
	if $cropSprite.get_frame() < 3:
		$cropSprite.set_frame($cropSprite.get_frame()+1)
	else:
		$cropSprite.set_frame(3+plantType)
	#if on
	$growthParticles.restart()
	value += growthValue

func butSold():
	if !Autoload.invFull():
		Autoload.updateInventory(plantType-1, value)
	else: 
		if Autoload.marketBought:
			value *= .01*Market.prices[plantType-1]
		Autoload.changeMoney(value)
	get_parent().get_node("plantButton").visible = true
	queue_free()
	
func applyColorValue():
	var percentChange = 100
	for i in range(3):
		percentChange += 255-color[i]
	percentChange /= 100.0
	#print(str(percentChange))
	value *= percentChange
	$Button.tooltip_text = str("sell for $", value)

func saveCropVars():
	var plantData = ""
	for i in plantDataArray:
		plantData += str(get(i)) + " "
	plantData += str(harvestable) + " "
	for i in range(3):
		plantData += str(color[i]) + " "
	plantData += str($cropSprite.get_frame())
	return plantData

func loadCropData(dataArr: Array):
	loaded = true
	for i in range(plantDataArray.size()):
		set(plantDataArray[i],int(dataArr[i+3]))
	value = float(dataArr[plantDataArray.size()+2])
	harvestable = dataArr[plantDataArray.size()+3] == "true"
	if harvestable:
		if !$Button.visible:
			$Button.visible = true
		$AnimationPlayer.play("done")
		$Button.tooltip_text = str("sell for $", value)
	for i in range(3):
		color[i] = int(dataArr[plantDataArray.size()+4+i])
	$cropSprite.modulate = Color8(color[0], color[1], color[2])
	$cropSprite.set_frame(int(dataArr[plantDataArray.size()+7]))
	
