extends Area2D

var attraction_force := 100

func _on_PickupRange_body_entered(body):
	body.follow(get_parent(), attraction_force)

func _on_PickupRange_body_exited(body):
	body.stop_following(get_parent())
