extends Node2D

var arr := []
var plot := preload("res://src/actors/cropBox.tscn")
var size := 9

func _ready():
	position = Vector2(size/2.0*-256,size/2.0*-256)
	visible = false
	Autoload.connect("sceneChange", Callable(self, "sceneAdjust"))
	for i in range(size):
		arr.append([])
		for j in range(size):
			var p = plot.instantiate()
			add_child(p)
			arr[i].append(p)
			arr[i][j].position = Vector2(i*256,j*256)
			arr[i][j].pos = Vector2(i,j)
	arr[4][4].butBought()

func checkNeighbors(p:Vector2):
	var x := p.x
	var y := p.y
	if arr[clamp(x-1,0,size-1)][y].checkBought():
		return true
	if arr[clamp(x+1,0,size-1)][y].checkBought():
		return true
	if arr[x][clamp(y-1,0,size-1)].checkBought():
		return true
	if arr[x][clamp(y+1,0,size-1)].checkBought():
		return true
	return false

func sceneAdjust(path):
	if path == "res://src/scenes/home.tscn":
		visible = false
	else:
		visible = true
		
func saveArrayVars():
	var arrayData = ""
	for child in get_children():
		if child.is_in_group("cropBox"):
			arrayData += "\n" + child.saveBoxVars()
	return arrayData

func loadArrData(file: FileAccess):
	file.get_line()
	while file.get_position() < file.get_length():
		var lineData = file.get_line().split(" ", false)
		
		if lineData.size() == 17:
			if lineData[0] == "false":
				Autoload.marketBought = false
			else:
				Autoload.marketBought = true
				Market.loadMarket(lineData.slice(1))
			break
			
		if lineData.size() > 1:
			arr[int(lineData[1])][int(lineData[2])].loadBoxData(lineData)
	
