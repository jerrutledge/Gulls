extends Control

signal restart

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _input(event):

	if event.is_action_pressed("pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			show()
		else:
			hide()
			
			
func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		var tree = get_tree()
		if tree.paused:
			tree.paused = false
			hide()
		emit_signal("restart")
