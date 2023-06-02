extends KinematicBody2D

const GRAVITY = 1000
const JUMP = 380
const ROTATION_STRENGTH = 10

var velocity = Vector2.ZERO
var motion
var playing = false
var hit_obstacle = false
var is_game_over = false

signal game_over
signal point
signal game_start

var skins = [
	"red",
	"yellow",
	"blue"
]

func _ready():	
	randomize()
	var random_skin = skins[round(rand_range(0,2))]
	$AnimatedSprite.play("fly_" + random_skin)


func _physics_process(delta):
	if not is_game_over:		
		if(Input.is_action_just_pressed("flap")):
			velocity.y = -JUMP
			$FlapAudio.play()
			if not playing:
				emit_signal("game_start")
			playing = true
	
	if playing:
		if(velocity.y < 0 and rotation_degrees > -30):
			rotation_degrees += - ROTATION_STRENGTH
		elif velocity.y > 80 and rotation_degrees < 30: 
			rotation_degrees += ROTATION_STRENGTH
		velocity.y += GRAVITY * delta
	
	motion = move_and_slide(velocity, Vector2(0,-1));

func _on_Detect_area_entered(area):
	if (area.name == "PipeArea"):
		emit_signal("point")
		$PointAudio.play()


func _on_Detect_body_entered(body):
	if body.is_in_group("obstacles") and not hit_obstacle:
		hit_obstacle = true#		
		is_game_over = true
		emit_signal("game_over")
		$AnimatedSprite.stop()
		$HitAudio.play()
