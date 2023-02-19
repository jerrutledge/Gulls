extends KinematicBody2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = 6000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	position.y -= velocity * delta
	
	if abs(position.y) > 10000:
		queue_free()
