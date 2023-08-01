extends CharacterBody2D



var speed = 250.0
var frequency = 30
var amplitude = 40
var time = 0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var bubble_emitted = false
var first = true
var mischief = 15 + (Game.playerstats["Punch"] * 5)
var damage = true
var DoT = 0
var MoT =   3 + (Game.playerstats["Punch"] * 2)
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("idle")
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").play("frost_idle")
	get_node("Timer").start()
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	damage = true
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		scale.x *= 2 *levelmodtest
		scale.y *= 2*levelmodtest
	
func shoot_at_mouse(start_pos,accuracy):
	
	
	if Game.current_effects.has("Duo-Shot"):
		var levelmodtest = (Game.current_effects_levels["Duo-Shot"] / 5.0) + 0.4
		mischief *= 0.75 * levelmodtest
		MoT *= 0.50 * levelmodtest
	if Game.current_effects.has("Tri-Shot"):
		var levelmodtest = (Game.current_effects_levels["Tri-Shot"] / 5.0) + 0.4
		mischief *= 0.6 * levelmodtest
		MoT *= 0.40 * levelmodtest
	if Game.current_effects.has("Quad-Shot"):
		var levelmodtest = (Game.current_effects_levels["Quad-Shot"] / 5.0) + 0.4
		mischief *= 0.4 * levelmodtest
		MoT *= 0.30 * levelmodtest
	
	self.global_position = start_pos
	direction = (get_global_mouse_position() - start_pos).normalized()
	if accuracy < 50:
		accuracy = 50
	else:
		accuracy = 100
	var rng = RandomNumberGenerator.new()
	var offshoot = 200 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1 + Game.playerstats["Shot Speed"] / 60)
	velocity.y += randoffshoot
	look_at(get_global_mouse_position())
	if velocity.x < 0 :
		rotation_degrees += 180

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#wave function
	if velocity.x != 0:
		time += delta
		var movement = cos(time * frequency) * amplitude
		position.y += movement * delta
	#wave function
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
		move_and_collide(reflect)
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		damage = true
	elif collision and second and !collision.get_collider().is_in_group("bullets") and !collision.get_collider().is_in_group("mob"):
		#If it collides a second time
		first = false
		second = false
		velocity.x = 0
		velocity.y = 0
		get_node("sticktimer").start()
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		damage = false
	if collision and collision.get_collider().is_in_group("bullets"):
		#If it hits another bullet
		first = false
		second = false
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal()) * 0.1
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		move_and_collide(reflect)
		damage = false
	if collision and collision.get_collider().is_in_group("mob"):
		get_node("AnimatedSprite2D").play("hit")
		if Game.current_effects.has("Freeze-Ray (Toygun)"):
			get_node("AnimatedSprite2D").play("frost_hit")
		first = false
		second = false
		velocity.x = 0
		velocity.y = 0
		get_node("sticktimer").start()
		if Game.current_effects.has("Rainbubble Blaster (Toygun)"):
			spawnbubble()
		if damage:
			collision.get_collider().hurt(0,mischief, DoT, MoT)
			damage = false
		#queue_free()


func spawnbubble():
	var rng = RandomNumberGenerator.new()
	var levelmodtest = Game.current_effects_levels["Rainbubble Blaster (Toygun)"] / 12.0
	var bubblerand = rng.randf() + levelmodtest
	if bubblerand > 0.9 and !bubble_emitted:
		var bubblespawn = bubble.instantiate()
		bubblespawn.position = self.global_position
		get_parent().add_child(bubblespawn)
		bubble_emitted = true
	elif bubblerand <= 0.9:
		bubble_emitted = true

func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.1).timeout
	queue_free()
