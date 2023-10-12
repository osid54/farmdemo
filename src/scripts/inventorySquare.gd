extends VBoxContainer

@export var cropType := 0

func _ready():
	Autoload.connect("invUpdate", Callable(self, "updateInv"))
	Market.marketChange.connect(onMarketChange)
	$cropIcon.chosenCrop = cropType
	$cropIcon.loadTexture()
	$Button.text = str(Autoload.seedInventory[cropType][0])
	$Button.tooltip_text = "sell for $"+str(Autoload.seedInventory[cropType][1])

func updateInv(signalP):
	if cropType == signalP:
		$Button.text = str(Autoload.seedInventory[cropType][0])
		$Button.tooltip_text = "sell for $"+str(Autoload.seedInventory[cropType][1])

func invSlotSold():
	Autoload.resetInventory(cropType)

func onMarketChange():
	if Autoload.marketBought:
		$Button.tooltip_text = str("sell for $", Autoload.seedInventory[cropType][1]*.01*Market.prices[cropType])
		if Autoload.seedInventory[cropType][1]*.01*Market.prices[cropType] != int(Autoload.seedInventory[cropType][1]*.01*Market.prices[cropType]):
			$Button.tooltip_text = "sell for $"+ "%.2f" % [Autoload.seedInventory[cropType][1]*.01*Market.prices[cropType]]
