extends Node2D

signal all_collectibles_collected
signal item_progress_updated(item_string)

export var next_level_name: String = ""

var items = []
var item_progess: String = "0/0"
var items_collected: int = 0
var items_total: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# get all collectibles
	items = get_tree().get_nodes_in_group("collectible")
	for item in items:
		item.connect("collected", self, "on_item_collected")
	items_total = items.size()
	update_item_progress()
	var par = get_parent()
	if par and par.has_method("finish_level"):
		var _idc = connect("all_collectibles_collected", par, "finish_level")

func on_item_collected(item_collected):
	var index = items.find(item_collected)
	if index != -1:
		items.remove(index)
		items_collected += 1
		update_item_progress()
		if items.size() <= 0:
			print_debug("All items collected")
			emit_signal("all_collectibles_collected")
	else:
		print_debug("Error: item couldn't be found: ", item_collected)

func update_item_progress():
	item_progess = "%d/%d" % [items_collected, items_total]
	emit_signal("item_progress_updated", item_progess)

func get_next_level():
	return next_level_name
