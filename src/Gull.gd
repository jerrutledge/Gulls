extends KinematicBody2D

export (float) var base_speed = 500.0
var dir:int = 1
var dive: bool = false
var rise: bool = false
var target_h_speed: float

export (float) var dive_accel = 3000.0
export (float) var max_rise_speed = 1800.0
export (float) var rise_accel = 3000.0
export (float) var rise_h_conversion = 7.0
export (float) var h_drag = 0.8
export (float) var turning_factor = 4.0
export (float) var dive_v_to_h_conversion_ratio = 0.6
export (float) var v_flattening_factor = 5.0

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

onready var sprite :AnimatedSprite = $AnimatedSprite

func _ready():
	sprite.play("flap")
	velocity.x = base_speed
	target_h_speed = base_speed

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
			print_debug(target_h_speed)
		dir = 1
	if Input.is_action_just_pressed("left"):
		if target_h_speed >= 0:
			target_h_speed = -max(abs(velocity.x), base_speed)
			print_debug(target_h_speed)
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
	if (dir > 0 and velocity.x < target_h_speed):
		velocity.x += target_h_speed * turning_factor * delta
	elif (dir < 0 and velocity.x > target_h_speed):
		velocity.x += target_h_speed * turning_factor * delta
	# execute the calculated movement
	velocity = move_and_slide(velocity)

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
