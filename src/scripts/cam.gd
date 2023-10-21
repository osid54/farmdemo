extends Camera2D

@export var speed := 0
var fixed_toggle_point = Vector2(0,0)

func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	
	position += direction * speed * delta

	if Input.is_action_just_pressed("moveMap"):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	if Input.is_action_pressed("moveMap"):
		slide_map_around()
	if Input.is_action_just_released("zoomMapIn"):
		zoom += Vector2(.1,.1)
	if Input.is_action_just_released("zoomMapOut"):
		zoom -= Vector2(.1,.1)
	
	position.x = clamp(position.x,-1000,1000)
	position.y = clamp(position.y,-1000,1000)
	zoom = zoom.clamp(Vector2(.5,.5),Vector2(1.5,1.5))

# slides the map around
func slide_map_around():
	var ref = get_viewport().get_mouse_position()
	self.global_position.x += (ref.x - fixed_toggle_point.x) / 80
	self.global_position.y += (ref.y - fixed_toggle_point.y) / 80
