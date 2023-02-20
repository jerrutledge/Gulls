extends Control

signal restart

var level_select: Control = null

func _ready():
	hide()
	level_select = get_parent().get_node("LevelSelect")

func _input(event):
	if event.is_action_pressed("pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			level_select.show()
			show()
		else:
			hide()
			level_select.hide()

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		var tree = get_tree()
		if tree.paused:
			tree.paused = false
			hide()
		emit_signal("restart")

