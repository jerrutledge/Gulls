extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 250
var velocity = 	Vector2.ZERO
var origin = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = position
	velocity = Vector2(speed, 0)

# Called every frame is the elapsed time since the previous frame.
func _process(delta):
	
	position += velocity * delta
	if position.x - origin.x > 400.0:
		velocity.x = -speed
	if position.x - origin.x < -400:
		velocity.x = speed
