extends StaticBody2D

var is_moving = true

func _ready():
	z_index = 0
	position.y = rand_range(-100, 50)
	
func _physics_process(_delta):
	if is_moving:
		position.x -= 2
		if position.x < -30:
			queue_free()
