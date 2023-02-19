extends Area2D

signal collected

var star_scene: PackedScene = preload("res://src/Collectibles/Stars.tscn")

func collect():
	emit_signal("collected", self)
	var stars = star_scene.instance()
	stars.position = position
	stars.emitting = true
	get_parent().call_deferred("add_child", stars)
	queue_free()


func _on_Player_body_entered(_body):
	collect()


func _on_Player_body_shape_entered(
		_body_rid, _body, _body_shape_index, _local_shape_index):
	collect()
