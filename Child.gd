extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
var velocity = 	Vector2.ZERO
var origin = Vector2.ZERO
var chasing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = position
	velocity = Vector2(speed, 0)

# Called every frame is the elapsed time since the previous frame.
func _process(delta):
	
	position += velocity * delta
	if position.x - origin.x > 400.0 and chasing == false:
		velocity.x = -speed
		set_scale(Vector2(-1, 1))
		
	if position.x - origin.x < -400 and chasing == false:
		velocity.x = speed
		set_scale(Vector2(1,1))


func _on_Vision_area_entered(area):
	chasing = true
	velocity.x *= 2
	
	
func _on_Vision_area_exited(area):
	chasing = false
	velocity.x /= 2
