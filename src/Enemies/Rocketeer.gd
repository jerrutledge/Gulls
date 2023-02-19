extends KinematicBody2D
onready var rocketScene = preload("res://src/Enemies/Rocket.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = 200
var cooldown = false
var cooldown_timer = 0
var cooldown_duration = 2
var  gull

# Called when the node enters the scene tree for the first time.
func _ready():
	gull = get_node("/root/Game/Level/Gull")


func _process(delta):
	if is_instance_valid(gull):
		if abs(gull.position.x - position.x) < 200 and not cooldown:
			var rocket = rocketScene.instance()
			rocket.position = position
			get_parent().add_child(rocket)
			cooldown = true
	if cooldown:
		cooldown_timer += delta
		if cooldown_timer > cooldown_duration:
			cooldown = false
			cooldown_timer = 0
