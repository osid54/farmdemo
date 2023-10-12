extends TextureRect

@export var chosenCrop := 0
var sprites := [preload("res://src/sprites/circle.png"), 
				preload("res://src/sprites/cross.png"), 
				preload("res://src/sprites/square.png"), 
				preload("res://src/sprites/diamond.png"), 
				preload("res://src/sprites/triangle.png"), 
				preload("res://src/sprites/invtriangle.png"), 
				preload("res://src/sprites/plus.png"), 
				preload("res://src/sprites/pluscurve.png")]

func _ready():
	pass
func loadTexture():
	texture = sprites[chosenCrop]
