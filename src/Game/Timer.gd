extends ColorRect

var time_elapsed: float = 0
onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _process(delta):
	time_elapsed += delta
	var minutes := floor(time_elapsed / 60)
	var seconds := fmod(time_elapsed, 60)
	var milliseconds := fmod(time_elapsed, 1) * 100
	var time_string := "%d:%02d:%02d" % [minutes, seconds, milliseconds]
	label.text = time_string

func reset():
	time_elapsed = 0
