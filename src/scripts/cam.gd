extends Camera2D

@export var speed := 0

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

	position.x = clamp(position.x,-1000,1000)
	position.y = clamp(position.y,-1000,1000)
