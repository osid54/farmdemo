extends Label

func _ready():
	label_settings.font_size = int(get_window().get_size().x/5.0)

