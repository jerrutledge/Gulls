extends KinematicBody2D

export (int) var base_speed = 500
var dir:int = 1
var dive: bool = false
var rise: bool = false

export (float) var dive_accel = 1500.0
export (float) var rise_speed = 700.0
export (float) var h_drag = 0.4

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func _ready():
	velocity.x = base_speed

func _physics_process(_delta):
	# collect inputs
	get_inputs()
	# calculate movement
	velocity.x = abs(velocity.x)
	if dive:
		# speed downwards
		velocity.y += dive_accel * _delta
		velocity.x += dive_accel * _delta * 0.5
	else:
		# flatten out
		velocity.y -= velocity.y * 5 * _delta
	if not dive and rise:
		if velocity.x > base_speed:
			velocity.x -= (velocity.x - base_speed) * h_drag * _delta
		if velocity.y <= -rise_speed:
			velocity.y = -rise_speed
		else:
			velocity.y -= rise_speed * 0.2
	velocity.x *= dir
	
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
