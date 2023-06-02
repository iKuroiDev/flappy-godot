extends Node



var pipe = preload('res://Pipes.tscn')
var ground = preload('res://Ground.tscn')
var is_playing = true
var current_score = 0

onready var tween = $StartMessage/Tween
onready var start_message = $StartMessage/Message
onready var game_over_tween = $Menus/Tween

var bgs = [
	"day",
	"night"
]

var pipe_skins = [
	"green",
	"red"
]

var pipe_skin = null

func _ready():	
	$GroundTimer.start()
	
	var random_pipe_skin = pipe_skins[round(randf())]
	pipe_skin = load("res://sprites/pipe-" + random_pipe_skin + ".png")
	
	spawn_obstacle(ground, Vector2(168, 480))
	
	randomize()
	var random_bg = bgs[round(randf())]
	
	$Background.texture = load("res://sprites/background-" + random_bg + ".png")

func _physics_process(_delta):
	pass
	
func _on_PipeTimer_timeout():
	if is_playing:
		spawn_obstacle(pipe, Vector2(310, 0), pipe_skin)

func _on_Flappy_game_over():
	game_over_tween.interpolate_property($Menus/MenuContainer, "modulate:a", 0, 1, 0.2)
	game_over_tween.start()
	
	GameManager.set_score(current_score)	
	$Menus/MenuContainer/HiScore.set_text("Hi Score: " + str(GameManager.hi_score))
		
	$Menus/MenuContainer/ScoreList.set_text(str(GameManager.scores[0]) + "\n" + str(GameManager.scores[1]) + "\n" + str(GameManager.scores[2]))
	
	is_playing = false
	$PipeTimer.stop()
	stop_obstacles()
	$Menus.visible = true

func stop_obstacles():
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		obstacle.is_moving = false

func _on_GroundTimer_timeout():
	if is_playing:
		spawn_obstacle(ground, Vector2(456, 480))

func spawn_obstacle(scene: PackedScene, position: Vector2, skin = null) -> Node:
	var obstacle = scene.instance()
	if(skin):
		obstacle.get_node("Pipe").texture = skin
		obstacle.get_node("Pipe2").texture = skin
		
	obstacle.position = position
	obstacle.add_to_group("obstacles")
	add_child(obstacle)
	return obstacle

func _on_Flappy_point():
	current_score += 1
	$CanvasLayer/Score.set_text(str(current_score))


func _on_Flappy_game_start():
	$PipeTimer.start()
	tween.interpolate_property(start_message, "modulate:a", 1, 0, 0.5)
	tween.start()

func _on_Button_pressed():
	get_tree().reload_current_scene()
	pass
