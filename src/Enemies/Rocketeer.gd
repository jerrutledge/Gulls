extends KinematicBody2D
onready var rocketScene = preload("res://src/Enemies/Rocket.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cooldown_timer = 0
var cooldown_duration = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):

	cooldown_timer += delta
	if cooldown_timer > cooldown_duration:
		var rocket = rocketScene.instance()
		rocket.position = position
		get_parent().add_child(rocket)
		cooldown_timer -= cooldown_duration
