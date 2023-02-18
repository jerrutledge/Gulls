extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = 300
var gull


# Called when the node enters the scene tree for the first time.
func _ready():
	gull = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var direction = (gull.position - position).normalized()
	position += direction * velocity * delta
	
