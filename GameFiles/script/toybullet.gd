
extends CharacterBody2D



var speed = 400.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var first = true
var mischief = 15.0 + (Game.playerstats["Punch"] * 5.0)
var dmg = 0
var DoT = 0
var player
var MoT = 0
var damage = true
var rng = RandomNumberGenerator.new()
var bubble_emitted = false
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").play("ice")
	get_node("Timer").start()
	scale.x = 1.0 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	scale.y = 1.0 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	damage = true
	
	
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		if scale.x < 1.5:
			scale.x = (4.0 * levelmodtest)
			scale.y = (4.0 * levelmodtest)
		else:
			scale.x *= (3.0 * levelmodtest)
			scale.y *= (3.0 * levelmodtest)
	
func shoot_at_mouse(start_pos,accuracy):
	
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
		
	
	mischief *= (1.0 + (Game.player_talents_current["Power"] * 0.02))
	MoT += (mischief * (Game.player_talents_current["Poison"] * 0.01))
	MoT += (MoT * (Game.player_talents_current["Curse of the Ages"] * 0.1))
	mischief *= (1.0 + (Game.player_talents_current["Promise"] * 0.002 * Game.roomcount))
	mischief *= player.boon_of_ages_dmg_mod
	MoT *= player.boon_of_ages_dmg_mod
	if Game.current_abilities.size() == 0 and Game.player_talents_current["Lone Wolf"]:
			mischief *= 1.15
			MoT *= 1.15
	
	self.global_position = start_pos
	direction = (get_global_mouse_position() - start_pos).normalized()
	
	var offshoot = 200.0 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1.0 + (Game.playerstats["Shot Speed"] / 15.0))
	velocity.y += randoffshoot
	look_at(get_global_mouse_position())

func spawnbubble():
	var levelmodtest = Game.current_effects_levels["Rainbubble Blaster (Toygun)"] / 12.0
	var bubblerand = rng.randf() + levelmodtest
	if bubblerand > 0.9 and !bubble_emitted:
		var bubblespawn = bubble.instantiate()
		bubblespawn.position = self.global_position
		get_parent().add_child(bubblespawn)
		bubble_emitted = true
	elif bubblerand <= 0.9:
		bubble_emitted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)		
	var gravmod = 3.0
		
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
		player.hittargetspeedboost()
	
		if Game.player_talents_current["Curse of Dread"] > 0:
			var dreadmod = player.setdreadtarget(self,collision.get_collider())
			mischief += (mischief * dreadmod)
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
