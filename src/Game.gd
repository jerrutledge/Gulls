extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _level_node = null
var starting_level_name = "Level"
var current_level_name

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_level(starting_level_name)


func _input(event):
	if event.is_action_pressed("restart"):
		load_level(current_level_name)


func load_level(level_name):
	if not (_level_node == null):
		_level_node.name = _level_node.name + "old"
		_level_node.queue_free()
	_level_node = load("res://levels/" + level_name + ".tscn").instance()
	_level_node.name = level_name
	add_child(_level_node)
	
	var _playerd = _level_node.get_node("Gull")
	current_level_name = level_name
	


func restart_level():
	pass
