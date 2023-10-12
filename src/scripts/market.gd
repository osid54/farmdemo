extends Node

@export var marketInterval := 15

var changeAmount = 5
var prices = []
var percentages = []

signal marketChange

func _ready():
	Autoload.tickUpdate.connect(change)
	for i in 8:
		prices.append(100)
		percentages.append(30)

func change():
	if Autoload.ticks % marketInterval == 0:
		for i in 8:
			var chance = randi_range(1, 100)
			if chance <= percentages[i]:
				prices[i] -= changeAmount
				percentages[i] -= 1
			elif chance > percentages[i] + 40:
				prices[i] += changeAmount
				percentages[i] += 1
			else:
				pass
		emit_signal("marketChange")

func saveMarket():
	var data = ""
	for i in 8:
		data += str(" ",prices[i])
	for i in 8:
		data += str(" ",percentages[i])
	return data

func loadMarket(arrData: Array):
	for i in 8:
		prices[i] = int(arrData[i])
	for i in 8:
		percentages[i] = int(arrData[8+i])
