
extends CharacterBody2D



var speed = 400.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var first = true
var mischief = 15 + (Game.playerstats["Punch"] * 5)
var damage = true
var bubble_emitted = false
var DoT = 0
var MoT = 0
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").play("ice")
	get_node("Timer").start()
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	damage = true
	if Game.current_effects.has("Big Shot"):
		if scale.x < 1.5:
			scale.x = 4
			scale.y = 4
		else:
			scale.x *= 3
			scale.y *= 3
func shoot_at_mouse(start_pos,accuracy):
	
	
	if Game.current_effects.has("Duo-Shot"):
		mischief *= 0.75
		DoT *= 0.50
	if Game.current_effects.has("Tri-Shot"):
		mischief *= 0.6
		DoT *= 0.40
	if Game.current_effects.has("Quad-Shot"):
		mischief *= 0.4
		DoT *= 0.30
	
	
	self.global_position = start_pos
	direction = (get_global_mouse_position() - start_pos).normalized()
	
	var rng = RandomNumberGenerator.new()
	var offshoot = 200 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1 + Game.playerstats["Shot Speed"] / 15)
	velocity.y += randoffshoot
	look_at(get_global_mouse_position())

func spawnbubble():
	var rng = RandomNumberGenerator.new()
	var bubblerand = rng.randf()
	if bubblerand > 0.92 and !bubble_emitted:
		var bubblespawn = bubble.instantiate()
		bubblespawn.position = self.global_position
		get_parent().add_child(bubblespawn)
		bubble_emitted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)		
	var gravmod = 3
		
	if collision and !collision.get_collider().is_in_group("bullets") and first and ((collision.get_normal().x == 0) and ((collision.get_normal().y == 1)) or (collision.get_normal().y == -1)):
		#bounce condition
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		var velocitymod
		if Game.current_effects.has("Bounce Blaster (Toygun)"):
			velocitymod = 0.9
		else:
			first = false
			velocitymod = 0.5
		velocity = velocity.bounce(collision.get_normal()) * velocitymod
		rotation = velocity.angle();
		move_and_collide(reflect)
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		damage = true
	elif collision and second and !collision.get_collider().is_in_group("bullets") and !collision.get_collider().is_in_group("mob"):
		#If it collides a second time
		first = false
		second = false
		velocity.x = 0
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		velocity.y = 0
		get_node("sticktimer").start()
		damage = false
	if collision and collision.get_collider().is_in_group("bullets"):
		#If it hits another bullet
		first = false
		second = false
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal()) * 0.1
		move_and_collide(reflect)
		damage = false
	if collision and collision.get_collider().is_in_group("mob"):
		first = false
		second = false
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		velocity.x = 0
		velocity.y = 0
		get_node("sticktimer").start()
		if damage:
			collision.get_collider().hurt(0,mischief, 0, MoT)
			damage = false
		#queue_free()
		
	
	if get_node("sticktimer").is_stopped():
		velocity.y += gravity * delta / gravmod #gravity




func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.1).timeout
	queue_free()
