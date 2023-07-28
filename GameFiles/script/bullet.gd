extends CharacterBody2D
var spark = preload("res://scene/player/spark.tscn")
var blood = preload("res://scene/mob/blood.tscn")
var flame = preload("res://scene/player/fire.tscn")
var bullet = preload("res://scene/player/bullet.tscn")

var speed = 650.0
var direction
var pierced = false
var damage = 25 + (Game.playerstats["Punch"] * 3)
var first = true
var DoT = 0 #damage over time
var MoT = 0

func _ready():
	get_node("AnimatedSprite2D").play("default")
	if Game.current_effects.has("Burn Shot (Gun)"):
		get_node("AnimatedSprite2D").modulate = Color8(255,47,15,255)
	if Game.current_effects.has("Flintlock (Gun)"):
		var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
		damage += ((5 + (Game.playerstats["Punch"] * 1.25)) * levelmodtest) #Around a 30% increase

func shoot_at_mouse(start_pos,accuracy):
	if Game.current_effects.has("Burn Shot (Gun)"):
		var levelmodtest = (Game.current_effects_levels["Burn Shot (Gun)"] / 5.0) + 0.4
		DoT = (3 +  (int(round(Game.playerstats["Punch"] * 0.4)))) * levelmodtest
	else:
		DoT = 0
	self.global_position = start_pos
	
	
	
	
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
	
	
	direction = (get_global_mouse_position() - start_pos).normalized()
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 2 / 10)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 2 / 10)
	if Game.current_effects.has("Flintlock (Gun)"):
		var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
		scale.x += (1.5 * levelmodtest)
		scale.y += (1.5 * levelmodtest)
	if scale.x > 5:
		scale.x = 5
	if scale.y > 5:
		scale.y = 5
	if Game.current_effects.has("Big Shot"):
		var levelmodtest = (Game.current_effects_levels["Big Shot"] / 5.0) + 0.4
		if scale.x < 1.5:
			scale.x = (4 * levelmodtest)
			scale.y = (4 * levelmodtest)
		else:
			scale.x *= (3 * levelmodtest)
			scale.y *= (3 * levelmodtest)
		
			
	
	var rng = RandomNumberGenerator.new()
	#var nameseed = rng.randf()
	var offshoot = 200 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = direction * speed * (1 + Game.playerstats["Shot Speed"] / 15)
	velocity.y += randoffshoot
	look_at(get_global_mouse_position())

func split_shot(start_pos, accuracy,dir):
	if Game.current_effects.has("Burn Shot (Gun)"):
		var levelmodtest = (Game.current_effects_levels["Burn Shot (Gun)"] / 5.0) + 0.4
		DoT = 3 +  (int(round(Game.playerstats["Punch"] * 0.4)))
		DoT *= levelmodtest	
	else:
		DoT = 0
	damage *= 1.0 / 3.0
	DoT *= 1.0 / 3.0
	pierced = true
	#dir = (get_global_mouse_position() - start_pos).normalized()
	self.global_position = start_pos
	scale.x = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	scale.y = 1 + (Game.playerstats["Bullet Size"] * 1.0 / 5.0)
	if Game.current_effects.has("Flintlock (Gun)"):
		var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
		scale.x += (1.5 * levelmodtest)
		scale.y += (1.5 * levelmodtest)
	if scale.x > 5:
		scale.x = 5
	if scale.y > 5:
		scale.y = 5
		
	var rng = RandomNumberGenerator.new()
	#var nameseed = rng.randf()
	accuracy =  100 + (int(Game.playerstats.get("Scope") * 5))
	var offshoot = 375 - accuracy
	var randoffshoot = rng.randi_range(-offshoot, offshoot)
	
	velocity = dir * speed * (1 + Game.playerstats["Shot Speed"] / 15)
	velocity.y += randoffshoot
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)
		
	
	if collision:
		var reflect
		if !collision.get_collider().is_in_group("mob") and Game.current_effects.has("Ricochet (Gun)") and first:
			#bounce condition
			reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			rotation = velocity.angle();
			move_and_collide(reflect)
			var spark_velocity = velocity.bounce(collision.get_normal())
			#move_and_collide(reflect)
			var rng = RandomNumberGenerator.new()
			var sparkcount = rng.randi_range(3,12)
			for i in sparkcount:
				var sparkspawn = spark.instantiate()
				sparkspawn.position = self.global_position
				get_parent().add_child(sparkspawn)
				sparkspawn.set_motion(spark_velocity,reflect)
			if Game.current_effects.has("Flame Shot (Gun)"):
				var flamespawn = flame.instantiate()
				flamespawn.position = self.global_position
				get_parent().add_child(flamespawn)
			
			var levelmodtest = Game.current_effects_levels["Ricochet (Gun)"] / 6.0
			var randchance = rng.randf() + levelmodtest
			if randchance > 0.95:
				pass
			else:
				first = false
		
		elif !collision.get_collider().is_in_group("mob"):
			reflect = collision.get_remainder().bounce(collision.get_normal())
			var spark_velocity = velocity.bounce(collision.get_normal())
			#move_and_collide(reflect)
			var rng = RandomNumberGenerator.new()
			var sparkcount = rng.randi_range(3,12)
			for i in sparkcount:
				var sparkspawn = spark.instantiate()
				sparkspawn.position = self.global_position
				get_parent().add_child(sparkspawn)
				sparkspawn.set_motion(spark_velocity,reflect)
			if Game.current_effects.has("Flame Shot (Gun)"):
				var flamespawn = flame.instantiate()
				flamespawn.position = self.global_position
				get_parent().add_child(flamespawn)
				
			self.queue_free()
		elif collision.get_collider().is_in_group("mob"):
			reflect = collision.get_remainder().bounce(collision.get_normal())
			#var blood_velocity = velocity.bounce(collision.get_normal())
			#move_and_collide(reflect)
			var rng = RandomNumberGenerator.new()
			var bloodcount = rng.randi_range(5,25)
			if collision.get_collider().is_in_group("ghost"):
				bloodcount = 0
			for i in bloodcount:
				var bloodspawn = blood.instantiate()
				bloodspawn.position = self.global_position
				get_parent().add_child(bloodspawn)
				bloodspawn.set_motion_noreflect(self.velocity.x / 10, 0)
			if Game.current_effects.has("Flame Shot (Gun)"):
				var flamespawn = flame.instantiate()
				flamespawn.position = self.global_position
				get_parent().add_child(flamespawn)
				
				
			if Game.current_effects.has("Piercing Shot (Gun)") and !pierced:
				collision.get_collider().hurt(damage,0,DoT,0)
				self.add_collision_exception_with(collision.get_collider())
				pierced = true
				var levelmodtest = (Game.current_effects_levels["Piercing Shot (Gun)"] / 5.0) + 0.4
				damage = damage / 2 * levelmodtest
				DoT = DoT / 2 * levelmodtest
			elif Game.current_effects.has("Split Shot (Gun)") and !pierced:
				var levelmodtest = (Game.current_effects_levels["Split Shot (Gun)"] / 12.0)
				var randchance = rng.randf() + levelmodtest
				var spawn = bullet.instantiate()
				if randchance > 0.5: # chance to spawn split 3
					var spawn2 = bullet.instantiate()
					get_parent().add_child(spawn2)
					var accuracy =  100
					spawn2.split_shot(self.global_position,accuracy,self.direction)
				if randchance > 0.95: # chance to spawn split 4
					var spawn3 = bullet.instantiate()
					get_parent().add_child(spawn3)
					var accuracy =  100
					spawn3.split_shot(self.global_position,accuracy,self.direction)
				get_parent().add_child(spawn)
				var accuracy =  100
				spawn.split_shot(self.global_position,accuracy,self.direction)
				
				collision.get_collider().hurt(damage,0,DoT,0)
				self.add_collision_exception_with(collision.get_collider())
				spawn.add_collision_exception_with(collision.get_collider())
				pierced = true
				damage = damage / 2
				DoT = DoT / 2
			else:
				collision.get_collider().hurt(damage,0,DoT,0)
				pierced = false
				self.queue_free()
