extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Timer").start() # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_motion(velocity, reflect):
	move_and_collide(reflect)
	self.linear_velocity = velocity * 0.2
	var rng = RandomNumberGenerator.new()
	var rand3 = rng.randi_range(-10,10)
	var rand4 = rng.randi_range(-10,10)
	#self.linear_velocity.x *= 1 / rand1 
	#self.linear_velocity.y *= 1 / rand2
	self.position.x += rand3
	self.position.y += rand4


func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.3)
	await get_tree().create_timer(0.3).timeout
	queue_free()
