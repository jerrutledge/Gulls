extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _level_node = null
var player = null
export(String) var starting_level_name = "Tutorial"
var current_level_name
var level_resource 

onready var _pause_menu = $CanvasLayer/Pause
onready var _death_screen = $CanvasLayer2/Death


# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_level(starting_level_name)
	
	_pause_menu.connect("restart", self, "_restart_level")


func _input(event):
	if event.is_action_pressed("restart"):
		_restart_level()

func _restart_level():
	_death_screen.hide()
	load_level(current_level_name)
	
func _on_player_death():
	_death_screen.show()

func load_level(level_name):
	if not (_level_node == null):
		_level_node.name = _level_node.name + "old"
		_level_node.queue_free()
	if level_name != current_level_name:
		level_resource = load("res://levels/" + level_name + ".tscn")
	_level_node = level_resource.instance()
	_level_node.name = level_name
	add_child(_level_node)
	
	player = _level_node.get_node("Gull")
	player.connect("died", self, "_on_player_death")
	current_level_name = level_name
	_death_screen.hide()
	

