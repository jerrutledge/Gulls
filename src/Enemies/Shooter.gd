extends KinematicBody2D
onready var bulletScene = preload("res://src/Enemies/Bullet.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = 50
var gull
var shooting_interval = 5
var shooting_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gull = get_node("/root/Game/Level/Gull")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(gull):
		var direction = (gull.position - position).normalized()
		position += direction * velocity * delta
		shooting_timer += delta
		if shooting_timer > shooting_interval:
			shooting_timer -= shooting_interval
			var bullet = bulletScene.instance()
			bullet.position = position
			bullet.direction = (gull.position - position).normalized()
			get_parent().add_child(bullet)
			
	
