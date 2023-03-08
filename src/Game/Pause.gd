extends Control

signal restart

var common_elements: Control = null
onready var game: Node = $"../.."

func _ready():
	hide()
	common_elements = get_parent().get_node("CommonElements")

func _input(event):
	if event.is_action_pressed("pause"):
		pause()
		
func pause():
	if game.is_menu_open():
		# death or success screens are already open
		return
	var tree = get_tree()
	tree.paused = not tree.paused
	if tree.paused:
		common_elements.show()
		show()
	else:
		hide()
		common_elements.hide()

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		var tree = get_tree()
		if tree.paused:
			tree.paused = false
			hide()
		emit_signal("restart")

