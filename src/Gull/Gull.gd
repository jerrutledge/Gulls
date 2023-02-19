extends KinematicBody2D

signal died

var dir: int = 1
var dive: bool = false
var rise: bool = false
var target_h_speed: float
var cam_height: float = 1080
var smooth_zoom = 1
var dead: bool = false

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

export(float) var base_speed = 500.0
export(float) var dive_accel = 3000.0
export(float) var max_rise_speed = 1800.0
export(float) var rise_accel = 3000.0
export(float) var rise_h_conversion = 7.0
export(float) var h_drag = 0.8
export(float) var turning_factor = 4.0
export(float) var dive_v_to_h_conversion_ratio = 0.6
export(float) var v_flattening_factor = 5.0
export(int) var left_clamp = -3000
export(int) var right_clamp = 12000
export(int) var top_clamp = 0
export(int) var bottom_clamp = 10000
export(float) var ZOOM_SPEED = 6.0
export(int) var floor_y = 6000

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var camera: Camera2D = $Camera2D
onready var tween: Tween = $Tween
const deadgull: PackedScene = preload("res://src/Gull/DeadGull.tscn")
const feather_particle: PackedScene = preload("res://src/Gull/Feathers.tscn")


func _ready():
	sprite.play("flap")
	velocity.x = base_speed
	target_h_speed = base_speed
	camera.limit_left = left_clamp
	camera.limit_right = right_clamp
	camera.limit_top = top_clamp
	camera.limit_bottom = bottom_clamp
	cam_height = ProjectSettings.get_setting("display/window/size/height")


func _physics_process(delta):
	# collect inputs
	get_inputs()
	# calculate movement
	process_movement(delta)

	process_animation()


func get_inputs():
	if Input.is_action_just_pressed("right"):
		if target_h_speed <= 0:
			target_h_speed = max(abs(velocity.x), base_speed)
		dir = 1
	if Input.is_action_just_pressed("left"):
		if target_h_speed >= 0:
			target_h_speed = -max(abs(velocity.x), base_speed)
		dir = -1
	if Input.is_action_pressed("down"):
		dive = true
	else:
		dive = false
	if Input.is_action_pressed("up") and not dive:
		rise = true
	else:
		rise = false


func process_movement(delta):
	# dive
	if dive:
		target_h_speed = dir * base_speed
		# speed downwards
		velocity.y += dive_accel * delta
	else:
		# flatten out
		velocity.y -= velocity.y * v_flattening_factor * delta
	# gain horizontal speed by air foil
	if velocity.y > 0:
		var accel = velocity.y * delta * dive_v_to_h_conversion_ratio
		velocity.x += accel if velocity.x > 0 else -accel
	# rise
	if rise and not dive:
		target_h_speed = dir * base_speed
		if abs(velocity.x) > base_speed:
			# lose momentum if rising
			var accel = (abs(velocity.x) - base_speed) * h_drag * delta
			velocity.x -= accel if velocity.x > 0 else -accel
			velocity.y -= accel * rise_h_conversion
		# rise at maximum the rise_speed
		if velocity.y <= -max_rise_speed:
			velocity.y = -max_rise_speed
		else:
			velocity.y -= rise_accel * delta
	# turn around
	if dir > 0 and velocity.x < target_h_speed:
		velocity.x += target_h_speed * turning_factor * delta
	elif dir < 0 and velocity.x > target_h_speed:
		velocity.x += target_h_speed * turning_factor * delta
	# execute the calculated movement
	velocity = move_and_slide(velocity)
	# clamp position
	position.x = clamp(position.x, left_clamp, right_clamp)
	position.y = clamp(position.y, top_clamp, floor_y)
	if position.y >= floor_y:
		die()
		return
	var h_fac = floor_y - position.y
	if position.y < floor_y / 2:
		h_fac = floor_y/2 + (floor_y/2 - position.y) / 5
	var target_zoom = max(h_fac / (cam_height/2), 1)
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	camera.zoom = Vector2(smooth_zoom, smooth_zoom)


func process_animation():
	# face the sprite in the correct direction
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	# handle animations
	var hspd = max(abs(target_h_speed), abs(velocity.x))
	if abs(velocity.x) < base_speed:
		hspd = abs(velocity.x)
	if dive:
		sprite.animation = "dive"
	elif hspd >= base_speed * 3:
		sprite.animation = "flap"
		sprite.frame = 1
		sprite.playing = false
	elif hspd < base_speed * 3 and hspd >= base_speed:
		sprite.speed_scale = hspd / base_speed
		sprite.animation = "flap"
		sprite.playing = true
	elif hspd < base_speed and hspd >= base_speed / 2:
		sprite.animation = "turn"
		sprite.frame = 0
	elif hspd < base_speed / 2 and hspd >= base_speed / 4:
		sprite.animation = "turn"
		sprite.frame = 1
	else:
		sprite.animation = "turn"
		sprite.frame = 2
	# handle rotation
	var rot = velocity.angle()
	if velocity.x < 0:
		rot = velocity.angle() - PI
	sprite.rotation = rot


func die():
	if dead:
		return
	dead = true
	remove_child(camera)
	#spawn corpse and feathers
	var corpse = deadgull.instance()
	var debris: CPUParticles2D = feather_particle.instance()
	get_parent().call_deferred("add_child", corpse)
	get_parent().call_deferred("add_child", debris)
	get_parent().call_deferred("add_child", camera)
	corpse.position = position
	corpse.linear_velocity.x = base_speed / 2 * dir
	corpse.linear_velocity.y = -40
	corpse.angular_velocity = 50
	debris.position = position
	debris.emitting = true
	camera.position = position
	emit_signal("died")
	queue_free()


func _on_hazard_area_entered(_area):
	die()


func _on_hazard_area_shape_entered(
		_area_rid, _area, _area_shape_index, _local_shape_index):
	die()


func _on_hazard_body_entered(_body):
	die()


func _on_hazard_body_shape_entered(
		_body_rid, _body, _body_shape_index, _local_shape_index):
	die()
