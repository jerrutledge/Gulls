extends RigidBody2D

onready var cam: Camera2D = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.offset = position
