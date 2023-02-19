extends Node2D

signal all_collectibles_collected
var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# get all collectibles
	items = get_tree().get_nodes_in_group("collectible")
	for item in items:
		item.connect("collected", self, "on_item_collected")

func on_item_collected(item_collected):
	var index = items.find(item_collected)
	if index != -1:
		items.remove(index)
		if items.size() <= 0:
			print_debug("All items collected")
			emit_signal("all_collectibles_collected")
	else:
		print_debug("Error: item couldn't be found: ", item_collected)
