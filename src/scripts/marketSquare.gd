extends Control

@export var cropType := 0

func _ready():
	Market.marketChange.connect(updateBox)
	$cropIcon.chosenCrop = cropType
	$cropIcon.loadTexture()
	if Market.prices[cropType] > 100:
		$Label.text = "+"
		$Label.modulate = "SEA_GREEN"
	elif Market.prices[cropType] < 100:
		$Label.text = "-"
		$Label.modulate = "MAROON"
	else:
		$Label.text = ""
		$Label.modulate = "LIGHT_GRAY"
	$Label.text += str(abs(Market.prices[cropType]-100))
	$Label.text += "%"

func updateBox():
	if Market.prices[cropType] > 100:
		$Label.text = "+"
		$Label.modulate = "SEA_GREEN"
	elif Market.prices[cropType] < 100:
		$Label.text = "-"
		$Label.modulate = "MAROON"
	else:
		$Label.text = ""
		$Label.modulate = "LIGHT_GRAY"
	$Label.text += str(abs(Market.prices[cropType]-100))
	$Label.text += "%"
