extends CharacterBody2D



var speed = 200.0
var frequency = 5
var amplitude = 0.3
var time = 0
var direction
var first = true
var mischief = 10 + (Game.playerstats["Punch"] * 3)
var damage = true
var DoT = 0
var MoT =   0
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("idle")
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").modulate = Color8(0,50,255,255)
	#get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)	
	damage = true
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		scale.x *= 2 * levelmodtest
		scale.y *= 2 * levelmodtest
	
func shoot_at_mouse(start_pos,accuracy):
	
	
	if Game.current_effects.has("Duo-Shot"):
		var levelmodtest = (Game.current_effects_levels["Duo-Shot"] / 5.0) + 0.4
		damage *= 0.75 * levelmodtest
		DoT *= 0.50 * levelmodtest
	if Game.current_effects.has("Tri-Shot"):
		var levelmodtest = (Game.current_effects_levels["Tri-Shot"] / 5.0) + 0.4
		damage *= 0.6 * levelmodtest
		DoT *= 0.40 * levelmodtest
	if Game.current_effects.has("Quad-Shot"):
		var levelmodtest = (Game.current_effects_levels["Quad-Shot"] / 5.0) + 0.4
		damage *= 0.4 * levelmodtest
		DoT *= 0.30 * levelmodtest
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#wave function
	if velocity.x != 0:
		time += delta
		var movement = cos(time * frequency) * amplitude
		position.y += movement * delta
		scale.y += movement * delta
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
			velocitymod = 0.7
		velocity = velocity.bounce(collision.get_normal()) * velocitymod
		rotation = velocity.angle();
		move_and_collide(reflect)
		damage = true
	elif collision and second and !collision.get_collider().is_in_group("bullets") and !collision.get_collider().is_in_group("mob"):
		#If it collides a second time
		first = false
		second = false
		velocity.x = 0
		velocity.y = 0
		get_node("sticktimer").start()
		damage = false
		queue_free()
	if collision and collision.get_collider().is_in_group("bullets"):
		#If it hits another bullet
		first = false
		second = false
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal()) * 0.1
		move_and_collide(reflect)
		damage = false
	if collision and collision.get_collider().is_in_group("mob"):
		#get_node("AnimatedSprite2D").play("hit")
		first = false
		second = false
		velocity.x = 0
		velocity.y = 0
		collision.get_collider().hypno()
		if damage:
			collision.get_collider().hurt(0,mischief, DoT, MoT)
			damage = false
		queue_free()




func _on_timer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.1).timeout
	queue_free()
