extends CharacterBody2D

@export var tilemap : TileMap
var reachable_distance := 10


func _surrounding_tiles(cell):
	var neighb = []
	for c in tilemap.get_surrounding_cells(cell):
		if tilemap.get_cell_source_id(1, c) != -1:
			neighb.append(c)
	return neighb

func _cells_to_update(cell):
	var a1 = _surrounding_tiles(cell)
	var a2 = []
	for c in a1:
		a2 += _surrounding_tiles(c)
		
	print(cell, a2)
	return a2

func _tile_clicked(pos):
	if not tilemap:
		return
		
	var tpos = tilemap.local_to_map(pos)
	var tself = tilemap.local_to_map(position)
	if abs(tpos.x - tself.x) + abs(tpos.y - tself.y) > reachable_distance:
		return
		
	tilemap.set_cell(1, tpos, 4, Vector2(2, 0))
	tilemap.set_cells_terrain_connect(1, tilemap.get_used_cells(1), 0, 3, false)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos = get_global_mouse_position()
			_tile_clicked(pos)


# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var x_dir := 1

@export var max_speed: float = 1300
@export var acceleration: float = 5500
@export var turning_acceleration : float = 9600
@export var deceleration: float = 6500
# ------------------------------------------ #

# GRAVITY ----- #
@export var gravity_acceleration : float = 5000
@export var gravity_max : float = 6000
# ------------- #

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 2000
@export var jump_cut : float = 0.4
@export var jump_gravity_max : float = 1800
@export var jump_hang_treshold : float = 1.0
@export var jump_hang_gravity_mult : float = 0.1
# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# ----------------------------------- #


# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left")),
		"y": int(Input.is_action_pressed("player_down")) - int(Input.is_action_pressed("player_up")),
		"just_jump": Input.is_action_just_pressed("player_jump") == true,
		"jump": Input.is_action_pressed("player_jump") == true,
		"released_jump": Input.is_action_just_released("player_jump") == true
	}


func _physics_process(delta: float) -> void:
	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	
	timers(delta)
	move_and_slide()



func x_movement(delta: float) -> void:
	x_dir = get_input()["x"]
	
	# Stop if we're not doing movement inputs.
	if x_dir == 0: 
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0,0), deceleration * delta).x
		return
	
	# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
	# Except if we are turning
	# (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		return
	
	# Are we turning?
	# Deciding between acceleration and turn_acceleration
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	
	# Accelerate
	velocity.x += x_dir * accel_rate * delta
	
	set_direction(x_dir) # This is purely for visuals


func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = hor_direction # remember direction


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		
		velocity.y = -jump_force
	
	# We're not actually interested in checking if the player is holding the jump button
#	if get_input()["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0


func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta


