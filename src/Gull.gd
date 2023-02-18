extends KinematicBody2D

export (int) var base_speed = 500
var dir:int = 1
var dive: bool = false
var rise: bool = false

export (float) var dive_accel = 1500.0
export (float) var max_rise_speed = 800.0
export (float) var rise_accel = 3000.0
export (float) var h_drag = 0.6
export (float) var turning_factor = 10.0
export (float) var dive_v_to_h_conversion_ratio = 0.5
export (float) var v_flattening_factor = 5.0

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func _ready():
	velocity.x = base_speed

func _physics_process(_delta):
	# collect inputs
	get_inputs()
	# calculate movement
	if dive:
		# speed downwards
		velocity.y += dive_accel * _delta
		# gain horizontal speed when diving
		var accel = dive_accel * _delta * dive_v_to_h_conversion_ratio
		velocity.x += accel if velocity.x > 0 else -accel
	else:
		# flatten out
		velocity.y -= velocity.y * v_flattening_factor * _delta
	if not dive and rise:
		if abs(velocity.x) > base_speed:
			# lose momentum if rising
			var accel = (abs(velocity.x) - base_speed) * h_drag * _delta
			velocity.x -= accel if velocity.x > 0 else -accel
		# rise at maximum the rise_speed
		if velocity.y <= -max_rise_speed:
			velocity.y = -max_rise_speed
		else:
			velocity.y -= rise_accel * _delta
	# turn around
	if (dir > 0 and velocity.x < base_speed):
		velocity.x += base_speed * turning_factor * _delta
	elif (dir < 0 and velocity.x > -base_speed):
		velocity.x -= base_speed * turning_factor * _delta
	# execute the calculated movement
	velocity = move_and_slide(velocity)

func get_inputs():
	if Input.is_action_just_pressed("right"):
		dir = 1
	if Input.is_action_just_pressed("left"):
		dir = -1
	if Input.is_action_pressed("down"):
		dive = true
	else:
		dive = false
	if Input.is_action_pressed("up") and not dive:
		rise = true
	else:
		rise = false
