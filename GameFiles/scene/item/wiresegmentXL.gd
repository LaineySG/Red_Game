extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.x > 20 or linear_velocity.x < -20:
		if linear_velocity.x > 20:
			linear_velocity.x = 20
		else:
			linear_velocity.x = -20
		set_collision_mask_value(5,false)
		set_collision_mask_value(8,false)
		set_collision_mask_value(7,false)
	if linear_velocity.x < 2 and linear_velocity.x > -2:
		set_collision_mask_value(5,true)
		set_collision_mask_value(8,true)
		set_collision_mask_value(7,true)
	if linear_velocity.y > 20 or linear_velocity.y < -20:
		if linear_velocity.y > 20:
			linear_velocity.y = 20
		else:
			linear_velocity.y = -20
		set_collision_mask_value(5,false)
		set_collision_mask_value(8,false)
		set_collision_mask_value(7,false)
	if linear_velocity.y < 2 and linear_velocity.y > -2:
		set_collision_mask_value(5,true)
		set_collision_mask_value(8,true)
		set_collision_mask_value(7,true)
		


func _on_timer_timeout():
	#print("LVX:  " + str(linear_velocity.x) + "       LVY:  " + str(linear_velocity.y))
	#print("Collision mask value:" + str(get_collision_mask_value(5)))
	$Timer.start()
