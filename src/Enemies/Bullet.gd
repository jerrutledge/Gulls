extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2(0,0)
var velocity = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	position += velocity * direction * delta
	if position.length() > 10000:
		queue_free()
