extends Button

@export var scenePath := ""

func _on_button_up():
	Autoload.sceneChanged(scenePath)
	get_tree().change_scene_to_file(scenePath)
