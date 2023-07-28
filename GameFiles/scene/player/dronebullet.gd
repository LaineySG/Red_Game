
extends CharacterBody2D



var speed = 750.0
var direction
var bubble = preload("res://scene/player/rainbubble.tscn")
var first = true
var mischief = 0
var dmg = 14 + (Game.playerstats["Punch"] * 3)
var damage = true
var bubble_emitted = false
var DoT = 0
var MoT = 0
var second = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if Game.current_effects.has("Freeze-Ray (Toygun)"):
		get_node("AnimatedSprite2D").modulate = Color8(0,50,255,255)
	get_node("AnimatedSprite2D").play("default")
	get_node("Timer").start()
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 2 / 10)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 2 / 10)	
	damage = true
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		scale.x *= 2 * levelmodtest
		scale.y *= 2 * levelmodtest
	
func shoot_at_target(start_pos,accuracy,target):
	
	if Game.current_effects.has("Duo-Shot"):
		var levelmodtest = (Game.current_effects_levels["Duo-Shot"] / 5.0) + 0.4
		mischief *= 1.25 * levelmodtest
		DoT *= 1.25 * levelmodtest
		MoT *= 1.25 * levelmodtest
		dmg *= 1.25 * levelmodtest
	if Game.current_effects.has("Tri-Shot"):
		var levelmodtest = (Game.current_effects_levels["Tri-Shot"] / 5.0) + 0.4
		mischief *= 1.40 * levelmodtest
		DoT *= 1.40 * levelmodtest
		MoT *= 1.40 * levelmodtest
		dmg *= 1.40 * levelmodtest
	if Game.current_effects.has("Quad-Shot"):
		var levelmodtest = (Game.current_effects_levels["Quad-Shot"] / 5.0) + 0.4
		mischief *= 1.65 * levelmodtest
		MoT *= 1.65 * levelmodtest
		DoT *= 1.65 * levelmodtest
		dmg *= 1.65 * levelmodtest
	
	
	self.global_position = start_pos
	direction = (target.global_position - start_pos).normalized()
	
	var rng = RandomNumberGenerator.new()
	var offshoot = 200 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1 + Game.playerstats["Shot Speed"] / 15)
	velocity.y += randoffshoot
	look_at(target.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)		
		
	if collision and !collision.get_collider().is_in_group("bullets") and first and ((collision.get_normal().x == 0) and ((collision.get_normal().y == 1)) or (collision.get_normal().y == -1)):
		#bounce condition
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		var velocitymod
		first = false
		velocitymod = 0.5
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
		velocity.x = 0
		velocity.y = 0
		if damage:
			collision.get_collider().hurt(dmg,mischief, DoT, MoT)
			damage = false
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0, 0.1)
		await get_tree().create_timer(0.1).timeout
		queue_free()
