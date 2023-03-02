extends Node2D

var loading: bool = false
var times_dict: Dictionary = {}
var _level_node: Node2D = null
var player: KinematicBody2D = null
export(String) var starting_level_name = "Level3"
var current_level_name: String
var level_resource: PackedScene
export var levels = ["Tutorial", "Level1", "Level2", "Level3"]

onready var _pause_menu = $PauseLayer/Pause
onready var _death_screen = $DeathLayer/Death
onready var timer: ColorRect = $HUD/TimerRect
onready var success_screen: CanvasLayer = $SuccessLayer
onready var level_selector: Control = $PauseLayer/LevelSelect
onready var hi_score: Control = $PauseLayer/HiScore
onready var hi_score_scores: GridContainer = $PauseLayer/HiScore/Scores
onready var score_display: Label = $HUD/TimerRect/VBoxContainer/Score

func _ready():
	load_level(starting_level_name)
	_pause_menu.connect("restart", self, "_restart_level")
	reset_default_visibilities()
	for level in levels:
		times_dict[level] = 999.0
		var lvl_button = Button.new()
		lvl_button.text = level
		lvl_button.connect("pressed", self, "load_level", [level])
		lvl_button.pause_mode = Node.PAUSE_MODE_PROCESS
		level_selector.add_child(lvl_button)
	update_hi_score()

func _input(event):
	if event.is_action_pressed("restart"):
		_restart_level()

func _restart_level():
	_death_screen.hide()
	load_level(current_level_name)
	
func _on_player_death():
	_death_screen.show()
	level_selector.show()
	hi_score.show()

func load_level(level_name):
	if loading:
		return
	loading = true
	reset_default_visibilities()
	if not (_level_node == null):
		_level_node.queue_free()
		# wait for old level to de-load
		yield(_level_node, "tree_exited")
	if level_name != current_level_name:
		level_resource = load("res://levels/" + level_name + ".tscn")
	_level_node = level_resource.instance()
	_level_node.name = "Level" #I currently find the Gull with a hardcoded path through 'Level'
	var _idc = _level_node.connect("item_progress_updated", self, "_on_score_update")
	add_child(_level_node)
	
	player = _level_node.get_node("Gull")
	_idc = player.connect("died", self, "_on_player_death")
	current_level_name = level_name
	timer.reset()
	loading = false

func finish_level():
	get_tree().paused = true
	var time: float = timer.get_time()
	update_time(current_level_name, time)
	success_screen.show()
	level_selector.show()
	hi_score.show()
	if not _level_node.has_method("get_next_level") or _level_node.get_next_level() == "":
		#stop
		pass

func next_level():
	if _level_node.has_method("get_next_level"):
		var new_level = _level_node.get_next_level()
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
	hi_score.hide()

func _on_score_update(score):
	score_display.text = score

func update_hi_score():
	# remove previous results
	for child in hi_score_scores.get_children():
		child.queue_free()
	for level in times_dict.keys():
		var level_label = Label.new()
		level_label.text = level
		hi_score_scores.add_child(level_label)
		var time_label = Label.new()
		time_label.text = "%.3f" % [times_dict[level]]
		if times_dict[level] == 999.0:
			time_label.text = "N/A"
		hi_score_scores.add_child(time_label)

func update_time(level, time):
	var curtime = times_dict[level]
	if curtime == 999.0 or curtime > time:
		times_dict[level] = time
		update_hi_score()
