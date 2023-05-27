extends RigidBody2D

var _prev_gravity_scale
var target_body :Node2D
var _attraction_force = 0

func _ready():
	apply_central_impulse(Vector2(0, -200.0))

func follow(body: Node2D, attraction_force):
	_attraction_force = attraction_force
	collision_mask &=  0b0 # LSB is world mask
	target_body = body
	_prev_gravity_scale = gravity_scale
	gravity_scale = 0

func stop_following(body: Node2D):
	collision_mask |=  0b1
	gravity_scale = _prev_gravity_scale
	if target_body == body:
		target_body = null

func _integrate_forces(state):
	if target_body:
		var p1 = get_global_transform().origin
		var p2 = target_body.get_global_transform().origin
		var dir = p1.direction_to(p2)
		dir = dir.rotated((randf() - 0.5)*3)
		var r2 = p1.distance_to(p2)
		apply_central_impulse(_attraction_force * dir)
