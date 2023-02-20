extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = 450
var gull
var pursuit_radius = 4000

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gull = get_node("/root/Game/Level/Gull")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(gull):
		if (gull.position - position).length() > pursuit_radius:
			return 
		var direction = (gull.position - position).normalized()
		position += direction * velocity * delta
	
