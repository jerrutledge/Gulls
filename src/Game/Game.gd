extends Node2D

var _level_node: Node2D = null
var player = null
export(String) var starting_level_name = "Level"
var current_level_name
var level_resource 

onready var _pause_menu = $CanvasLayer/Pause
onready var _death_screen = $CanvasLayer2/Death
onready var timer = $HUD/TimerRect

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
	get_tree().paused = false
	if not (_level_node == null):
		_level_node.name = _level_node.name + "old"
		_level_node.queue_free()
	if level_name != current_level_name:
		level_resource = load("res://levels/" + level_name + ".tscn")
	_level_node = level_resource.instance()
	_level_node.name = "Level" #I currently find the Gull with a hardcoded path through 'Level'
	add_child(_level_node)
	
	player = _level_node.get_node("Gull")
	player.connect("died", self, "_on_player_death")
	current_level_name = level_name
	_death_screen.hide()
	timer.reset()

func finish_level():
	get_tree().paused = true
	$SuccessLayer.visible = true

func next_level():
	if _level_node.has_method("get_next_level"):
		var new_level = _level_node.get_next_level()
		print_debug(new_level)
		load_level(new_level)
	else:
		print_debug("Can't get new level")
