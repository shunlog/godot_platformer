extends CharacterBody2D

# parameters
@export var JUMP_DURATION_TICKS: int = 16 # ticks 
@export var JUMP_SPEED_PER_TICK: float = 5.01 # pix/tick
@export var GRAVITY_PER_TICK: float = 0.4 # pix/tick
# 37.5 (tile/sec) * 16/60 (pix/tick * sec/tile) = 10 pix/tick
@export var MAX_FALLING_VELOCITY_PER_TICK: float = 10.0 # pix/tick
@export var MAX_RUN_SPEED_PER_TICK : float = 3.0 # pix/tick
@export var RUN_ACCELERATION_PER_TICK : float = 0.08 # pix/tick
@export var RUN_SLOWDOWN_PER_TICK : float = 0.2 # pix/tick

# computed constants
var GRAVITY: float = GRAVITY_PER_TICK * 60 # pix/second
var JUMP_VELOCITY: float = - JUMP_SPEED_PER_TICK * 60 # pix/second
var MAX_RUN_SPEED: float = MAX_RUN_SPEED_PER_TICK * 60 # pix/second
var RUN_ACCELERATION: float = RUN_ACCELERATION_PER_TICK * 60 # pix/second
var RUN_SLOWDOWN: float = RUN_SLOWDOWN_PER_TICK * 60 # pix/second

# state variables
var jump_duration_timer: int = 0
var MAX_FALLING_VELOCITY: float = MAX_FALLING_VELOCITY_PER_TICK * 60

func _physics_process(_delta):
	# Handle Y-movement
	if is_on_floor():
		MAX_FALLING_VELOCITY = MAX_FALLING_VELOCITY_PER_TICK * 60 # pix/second
		
	if Input.is_action_pressed("player_jump") and jump_duration_timer > 0:
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("player_jump"):
		jump_duration_timer = 0

	if is_on_ceiling():
		jump_duration_timer = 0
		velocity.y = 0.0

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		jump_duration_timer = JUMP_DURATION_TICKS
		velocity.y = JUMP_VELOCITY

	if not is_on_floor():
		velocity.y += GRAVITY
		velocity.y = min(MAX_FALLING_VELOCITY, velocity.y)
		
	jump_duration_timer -= 1
	# terraria does this for some reason
	# source: https://github.com/tModLoader/tModLoader/wiki/Terraria.Player.Update()-Execution-Order
	MAX_FALLING_VELOCITY += 0.01 * 60 
	
	# Handle X-movement
	# direction is in the interval [-1.0, 1.0]
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x += direction * RUN_ACCELERATION
		if direction == 1:
			velocity.x = min(velocity.x, MAX_RUN_SPEED)
		else:
			velocity.x = max(velocity.x, -MAX_RUN_SPEED)
	if not direction or direction * velocity.x < 0:
		velocity.x = move_toward(velocity.x, 0, RUN_SLOWDOWN)

	# move_and_slide() already takes delta time into account
	move_and_slide()
