extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Timer").start() # Replace with function body.
	modulate = Color(1,0,0)
	
func color(x):
	modulate = x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_motion(velocity, _reflect):
	if _reflect:
		move_and_collide(_reflect)
	self.linear_velocity = velocity * 0.8
	var rng = RandomNumberGenerator.new()
	var rand3 = rng.randi_range(-10,10)
	var rand4 = rng.randi_range(-10,10)
	self.position.x += rand3
	self.position.y += rand4
	
func set_motion_noreflect(vx, vy):
	self.linear_velocity.x = vx * 0.8
	self.linear_velocity.y = vy * 0.8
	var rng = RandomNumberGenerator.new()
	var rand1 = rng.randf_range(1.0,10.0)
	var rand2 = rng.randf_range(1.0,10.0)
	var rand3 = rng.randf_range(-10.0,10.0)
	var rand4 = rng.randf_range(-10.0,10.0)
	self.linear_velocity.x *= 1.0 / rand1 
	self.linear_velocity.y *= 1.0 / rand2
	self.position.x += rand3
	self.position.y += rand4


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.2).timeout
	queue_free()
