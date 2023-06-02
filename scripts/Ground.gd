extends StaticBody2D

var is_moving = true

func _ready():
	pass 

func _physics_process(_delta):
	if is_moving:
		position.x -= 2
		
		if position.x <= -168:
			queue_free()
