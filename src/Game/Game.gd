extends Node2D

var loading: bool = false
var _level_node: Node2D = null
var player: KinematicBody2D = null
export(String) var starting_level_name = "Level3"
var current_level_name: String
var level_resource: PackedScene
export var levels = ["Tutorial", "Level"]

onready var _pause_menu = $PauseLayer/Pause
onready var _death_screen = $DeathLayer/Death
onready var timer: ColorRect = $HUD/TimerRect
onready var success_screen: CanvasLayer = $SuccessLayer
onready var level_selector: Control = $PauseLayer/LevelSelect

func _ready():
	load_level(starting_level_name)
	_pause_menu.connect("restart", self, "_restart_level")
	reset_default_visibilities()
	for level in levels:
		var lvl_button = Button.new()
		lvl_button.text = level
		lvl_button.connect("pressed", self, "load_level", [level])
		lvl_button.pause_mode = Node.PAUSE_MODE_PROCESS
		level_selector.add_child(lvl_button)

func _input(event):
	if event.is_action_pressed("restart"):
		_restart_level()

func _restart_level():
	_death_screen.hide()
	load_level(current_level_name)
	
func _on_player_death():
	_death_screen.show()
	level_selector.show()

func load_level(level_name):
	if loading:
		return
	loading = true
	reset_default_visibilities()
	if not (_level_node == null):
		_level_node.name = _level_node.name + "old"
		_level_node.queue_free()
		# wait for old level to de-load
		yield(_level_node, "tree_exited")
	if level_name != current_level_name:
		level_resource = load("res://levels/" + level_name + ".tscn")
	_level_node = level_resource.instance()
	_level_node.name = "Level" #I currently find the Gull with a hardcoded path through 'Level'
	add_child(_level_node)
	
	player = _level_node.get_node("Gull")
	var _idc = player.connect("died", self, "_on_player_death")
	current_level_name = level_name
	timer.reset()
	loading = false

func finish_level():
	get_tree().paused = true
	success_screen.show()
	level_selector.show()

func next_level():
	if _level_node.has_method("get_next_level"):
		var new_level = _level_node.get_next_level()
		print_debug("new level: '", new_level, "'")
		if new_level:
			load_level(new_level)
		else:
			print_debug("No new level :(")
	else:
		print_debug("Can't get new level")

func reset_default_visibilities():
	get_tree().paused = false
	_pause_menu.hide()
	_death_screen.hide()
	success_screen.hide()
	level_selector.hide()


