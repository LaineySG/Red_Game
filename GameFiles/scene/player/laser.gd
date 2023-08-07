
extends CharacterBody2D



var speed = 600.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var first = true
var mischief = 8 + (Game.playerstats["Punch"] * 6)
var DoT = 0
var MoT = 0
var dmg = 0
var damage = true
var bubble_emitted = false
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").modulate = Color8(0,50,255,255)
	get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	scale.x = 1.0 + (Game.playerstats["Bullet Size"] * 2 / 10)
	scale.y = 1.0 + (Game.playerstats["Bullet Size"] * 2 / 10)	
	damage = true
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		scale.x *= 2.0 * levelmodtest
		scale.y *= 2.0 * levelmodtest
	
func shoot_at_target(start_pos,accuracy,target):
	
	if Game.current_effects.has("Duo-Shot"):
		var levelmodtest = (Game.current_effects_levels["Duo-Shot"] / 5.0) + 0.4
		mischief *= 0.75 * levelmodtest
		DoT *= 0.50 * levelmodtest
	if Game.current_effects.has("Tri-Shot"):
		var levelmodtest = (Game.current_effects_levels["Tri-Shot"] / 5.0) + 0.4
		mischief *= 0.6 * levelmodtest
		DoT *= 0.40 * levelmodtest
	if Game.current_effects.has("Quad-Shot"):
		var levelmodtest = (Game.current_effects_levels["Quad-Shot"] / 5.0) + 0.4
		mischief *= 0.4 * levelmodtest
		DoT *= 0.30 * levelmodtest
		
	if Game.current_effects.has("Pump-action (Toygun)"):
		var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
		mischief *= 1.0 + (0.2 * levelmodtest)
		DoT *= 1.0 + (0.20 * levelmodtest)
		
	
	self.global_position = start_pos
	direction = (target.global_position - start_pos).normalized()
	
	var rng = RandomNumberGenerator.new()
	var offshoot = 200.0 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1.0 + (Game.playerstats["Shot Speed"] / 15.0))
	velocity.y += randoffshoot
	look_at(target.global_position)

func spawnbubble():
	var rng = RandomNumberGenerator.new()
	var bubblerand = rng.randf()
	if bubblerand > 0.92 and !bubble_emitted:
		var bubblespawn = bubble.instantiate()
		bubblespawn.position = self.global_position
		get_parent().add_child(bubblespawn)
		bubble_emitted = true
	else:
		bubble_emitted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)		
		
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
		if damage:
			collision.get_collider().hurt(0,mischief, DoT, MoT)
			damage = false
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.1)
		await get_tree().create_timer(0.1).timeout
		queue_free()
