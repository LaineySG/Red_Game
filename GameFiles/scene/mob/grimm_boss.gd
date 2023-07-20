extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("../../Player")
var wtf = preload("res://scene/mob/wtf.tscn")
var anger = preload("res://scene/mob/amgry.tscn")
var heart = preload("res://scene/mob/heart.tscn")
var bullet = preload("res://scene/player/grimm_projectile.tscn")
var coin = preload("res://scene/item/coin.tscn")
var boo = preload("res://scene/mob/boo.tscn")
var fluzar = preload("res://scene/mob/fluzar.tscn")
var rng = RandomNumberGenerator.new()
@onready var alive_collision = $alive_shape
@onready var dead_collision = $dead_shape
var chase = false
var dying = false
var frozen = false
var froststack = 0
var frogtarget
var webstuck = false
var tutorial_area_2_cutscene_1 = false
@onready var webstucktimer = $webstucktimer
var dead = false
var player_higher = false
var is_in_cutscene
var nopatience = false
var speedbase
var blood = preload("res://scene/mob/blood.tscn")
var berserk = false
var repath = false
var hypnotized = false
var hypnoimmune = true
var casting = false
var teleportpoof = preload("res://scene/item/smokepoof.tscn")
var frosted = 0
var hit = false
@onready var anim = get_node("AnimatedSprite2D")

var health = 2500 #2500
var patience = 2000 #2000
var damage = 25
var speed = 325
var level = 1 # level 2 and 3 will unlock new "berserk mode" abilities later


var hypno_nearby_enemies = []
var direction
var attack_ready = false
@onready var attacktimer = get_node("Attackbox/AttackTimer")
@onready var hpbar = get_node("hp")
@onready var patbar = get_node("patience")
@onready var navi = get_node("NavigationAgent2D") as NavigationAgent2D
var web = preload("res://scene/item/web.tscn")
var path: Array = []
@onready var pathtimer = $NavigationAgent2D/Timer
@onready var ally_timer = $ally_timer
@onready var casttimer = $cast_timer
@onready var jumptimer = $NavigationAgent2D/jumptimer
@onready var repathtimer = $NavigationAgent2D/repathtimer

func navigate():
	pass
	
func _process(_delta):
	if is_in_cutscene:
		velocity.x = 0
	if dead or dying:
		velocity.x = 0
	if froststack > 0:
		speed = speedbase * pow(0.9,froststack)
	if frozen:
		get_node("AnimatedSprite2D").modulate = Color(0.7,0.7,0.7,0.8)
	
func _ready():
	speedbase = speed
	hpbar.max_value = health
	hpbar.value = health
	patbar.max_value = patience
	patbar.value = patience
	
func get_nav_path():
	if chase and !dying and !dead and !hypnotized:
		navi.target_position = player.global_position
	if chase and !dying and !dead and hypnotized:
		if frogtarget == null:
			var cursor = 999999999.0
			for children in get_parent().get_children():
				if children.is_in_group("mob"):
					var currentdist = self.position.distance_to(children.position)
					if currentdist < cursor and children != self and !children.nopatience and !children.dead and !children.dying:
						frogtarget = children
						cursor = currentdist
			#get closets child
		if get_node("Attackbox").overlaps_body(frogtarget):
			attack()
				
		if frogtarget != null:
			navi.target_position = frogtarget.global_position
	
	if hypno_nearby_enemies != null and hypnotized and frogtarget != null:
		#if there are nearby enemies
		frogtarget.hypnoslow(self)
	if tutorial_area_2_cutscene_1:
		navi.target_position = Vector2(1475,375)

func _on_timer_timeout():
	if chase and !dying and !dead:
		get_nav_path()

func setcombatinteractions(x):
#	get_node("playerdetection").set_collision_layer_value(7,x)
	if x == false:
		set_collision_layer_value(10,x)
		set_collision_layer_value(7,x)
#	get_node("Attackbox").set_collision_layer_value(7,x)
#	get_node("Hitbox").set_collision_layer_value(7,x)
#	get_node("Hitbox").set_collision_mask_value(7,x)
	
func apply_gravity(delta):
	move_and_slide()
	velocity.y += gravity * delta
	
func _apply_movement(delta, nomove = false):
	velocity.y += gravity * delta
	if chase or hypnotized:
		navi.get_next_path_position()
	if nomove:
		velocity.x = 0
		if !hypnotized:
			direction = (player.position - self.position).normalized()
		else:
			if frogtarget != null:
				direction = (frogtarget.position - self.position).normalized()
			
	else:
		direction = to_local(navi.get_next_path_position()).normalized() 
	if (direction.x > 0 == true and player.camo == false) or tutorial_area_2_cutscene_1:
		if !nomove and !webstuck:
			velocity.x = direction.x * speed
		get_node("AnimatedSprite2D").flip_h = true
		if get_node("Attackbox/CollisionShape2D").position.x < 0 or tutorial_area_2_cutscene_1:
			get_node("Attackbox/CollisionShape2D").position.x *= -1
			get_node("dead_shape").position.x *= -1
	elif direction.x < 0 == true and player.camo == false:
		if !nomove and !webstuck:
			velocity.x = direction.x * speed
		get_node("AnimatedSprite2D").flip_h = false
		if get_node("Attackbox/CollisionShape2D").position.x > 0:
			get_node("Attackbox/CollisionShape2D").position.x *= -1
			get_node("dead_shape").position.x *= -1
	if !nomove and abs(player.position.x - self.position.x) < 50 and player.position.y > self.position.y and !hypnotized: #if on top of player, move
		velocity.x -= 500
	if frogtarget != null: 
		if !nomove and abs(frogtarget.position.x - self.position.x) < 10 and hypnotized: #if on top of frog enemy, move
			velocity.x = -5000
	if player.camo:
		velocity.x = 0
	if hypnotized and frogtarget != null:
		if frogtarget.nopatience:
			velocity.x = 0
			hypnotized = false
			hypnoimmune = true
			attack_ready = false
			chase = false
	if tutorial_area_2_cutscene_1 == true:
		velocity.x = 300
	if velocity.x > speedbase * 3:
		velocity.x = speedbase
	move_and_slide()
		
func _on_playerdetection_body_entered(body): # on player entering detection sphere
	if body.name == "Player" and !hypnotized:
		chase = true
	if body.is_in_group("mob") and hypnotized:
		chase = true

func _on_playerdetection_body_exited(body): # on player leaving detection sphere
	if body.name == "Player" and !hypnotized:
		chase = false
	if body.is_in_group("mob") and hypnotized:
		chase = false

func interactions(on):
	if on:
		set_collision_layer_value(7,true) # makes it interactible withable.
		set_collision_layer_value(10,false) # makes it interactible withable.
	elif !on:
		set_collision_layer_value(7,false) # makes it uninteractible withable.
		set_collision_layer_value(10,true) # makes it interactible withable.

func _love():
	if !berserk and !frozen:
		var hearts = rng.randi_range(1,4)
		for i in hearts:
			var heartspawn = heart.instantiate()
			heartspawn.position = self.global_position + Vector2(rng.randi_range(-40,40),rng.randi_range(-40,40))
			get_parent().add_child(heartspawn)
			
func freeze():
	frozen = false
	
	
func hurt(dmg,patiencedmg,DoT,MoT): # when hitbox is shot
	
	var crit_dmg = false
	if damage > 5 or patiencedmg > 5:
		var critchance = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
		if critchance > 0.99:
			crit_dmg = true
			dmg *= 2
			patiencedmg *= 2

	if dmg > 0:
		var dmgnumspawn = wtf.instantiate()
		var locationmodx = rng.randi_range(-50,50)
		dmgnumspawn.position = global_position
		dmgnumspawn.position.x += locationmodx
		dmgnumspawn.position.y -= 50
		dmgnumspawn.settext(str(round(dmg)))		
		if crit_dmg:
			dmgnumspawn.scale = Vector2(1.5,1.5)
			dmgnumspawn.setcolor(Color.GOLD)
		else:
			dmgnumspawn.modulate = Color.DARK_RED
		get_parent().add_child(dmgnumspawn)
	if patiencedmg > 0:
		var dmgnumspawn = wtf.instantiate()
		var locationmodx = rng.randi_range(-50,50)
		dmgnumspawn.position = global_position
		dmgnumspawn.position.x += locationmodx
		dmgnumspawn.position.y -= 50
		if berserk:
			dmgnumspawn.settext("0")
		else:
			dmgnumspawn.settext(str(round(patiencedmg)))
		if crit_dmg:
			dmgnumspawn.scale = Vector2(1.5,1.5)
			dmgnumspawn.setcolor(Color.GOLD)
		else:
			dmgnumspawn.modulate = Color.DARK_CYAN
		get_parent().add_child(dmgnumspawn)
	
	
	if !dying and !dead:	
		if dmg > 0:
			hpbar.value -= dmg
			berserk = true
			if nopatience:
				speed = speed + 75
				damage += 10
			nopatience = false
			velocity.x = -direction.x * 2000 * (Game.playerstats["Shot Weight"] * 1/20)
		elif patiencedmg > 0 and !berserk and !dying and !dead and !frozen: # if shot w/ toy gun
			if patbar.value >= (patbar.max_value / 1.7) or patbar.value == 0: # over 60% ish or happy
				patbar.value -= patiencedmg
				var wtfspawn = wtf.instantiate()
				wtfspawn.position = self.global_position
				get_parent().add_child(wtfspawn)
			elif !berserk: # under 50%
				patbar.value -= patiencedmg
				var angerspawn = anger.instantiate()
				angerspawn.position = self.global_position
				get_parent().add_child(angerspawn)
			velocity.x = -direction.x * 750 * (Game.playerstats["Shot Weight"] * 1/20)
			if Game.current_effects.has("Freeze-Ray (Toygun)"):
				if froststack <= 4:
					froststack += 1
				var frosty = get_tree().create_tween()
				frosty.tween_property(get_node("AnimatedSprite2D"),"modulate", Color(.3,.3,.8,.9),0.2)
				await get_tree().create_timer(2.0).timeout
				var returner = get_tree().create_tween()
				returner.tween_property(get_node("AnimatedSprite2D"),"modulate", Color(1,1,1,.95), 0.5)
				if froststack >=1:
					froststack -=1
				frosted += 1
			if Game.current_effects.has("Shrink-Ray (Toygun)"):
				var randchance = rng.randf() +  (0.01 * Game.playerstats["Luck"])
				if scale.x >= 0.6 and randchance > 0.95:
					scale.x *= 0.95
					scale.y *= 0.95
				if damage > 1 and randchance > 0.95:
					damage -= (0.10 * damage)
				else:
					damage = 1
			var randchance = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
			if Game.current_effects.has("Web Shot (Toygun)") and randchance > 0.99:
				# -33 to +33 x ; -33 to +10 y
				self.velocity.x = 0
				webstucktimer.start()
				webstuck = true
				var webx = rng.randi_range(-33,33)
				var weby = rng.randi_range(-33,10)
				var webspawn = web.instantiate()
				webspawn.position.x = self.global_position.x + webx
				webspawn.position.y = self.global_position.y + weby
				get_parent().call_deferred("add_child", webspawn)
				#webspawn.position = self.global_position
				#webspawn._set_parent(self,self.global_position)
		if !chase and anim.animation != "Death" and anim.animation != "attack":
			chase = true
		if DoT > 0:
			afflictDoT(DoT,0)
		if MoT > 0:
			afflictDoT(0,MoT)
			
		if hpbar.value <= 75 and speed < 175:
			speed = 150 + 25
		elif hpbar.value <= 50 and speed < 225:
			speed = 150 + 75
		elif hpbar.value <= 25 and speed < 275:
			speed = 150 + 125
		
		if Game.current_effects.has("Vampire (Gun)"):
			player.heal(0.1 * dmg)
		
func hypno():
	if !hypnoimmune:
		hypnotized = true
		attack_ready = false
		ally_timer.start()
		get_node("AnimatedSprite2D").material.set_shader_parameter("new", Color.HOT_PINK)
		
		
func afflictDoT(DoT, MoT):
	await get_tree().create_timer(1.0).timeout
	var ouchie = get_tree().create_tween()
	ouchie.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie.finished
	var returner = get_tree().create_tween()
	returner.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,MoT,0,0)
	await get_tree().create_timer(1.0).timeout
	var ouchie2 = get_tree().create_tween()
	ouchie2.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie2.finished
	var returner2 = get_tree().create_tween()
	returner2.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,MoT,0,0)
	await get_tree().create_timer(1.0).timeout
	var ouchie3 = get_tree().create_tween()
	ouchie3.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie3.finished
	var returner3 = get_tree().create_tween()
	returner3.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,MoT,0,0)
		
func attack():
	if !hypnotized:
		player.hurt(damage,0)
	elif frogtarget != null and hypnotized:
		frogtarget.hurt(0,damage/2.0,0,0)
		
func hypnoslow(_caster):
	#simulates fighting a hypnotized alien
	velocity.x = 0
	webstuck = true
	attack_ready = false
	webstucktimer.start()
	
	
	
func _on_attackbox_body_entered(body):
	if body.name == "Player" and !hypnotized:
		attack_ready = true
		chase = false
	if body.name == "Player" and nopatience:
		#_love()
		pass
	if body.is_in_group("mob") and hypnotized:
		#frogtarget = body.get_parent()
		attack_ready = true
		chase = false
		
func pierce():
	set_collision_layer_value(7,false) # makes it uninteractible withable.
	set_collision_layer_value(10,true) # makes it interactible withable.
	await get_tree().create_timer(0.8).timeout
	set_collision_layer_value(7,true) # makes it interactible withable.
	set_collision_layer_value(10,false) # makes it interactible withable.
		
	
				
func _on_attackbox_body_exited(body):
	if body.name == "Player" and !hypnotized:
		attack_ready = false
		chase = true
		get_node("Attackbox/AttackTimer").stop()
	
	if body.is_in_group("mob") and hypnotized:
		attack_ready = false
		chase = true
		get_node("Attackbox/AttackTimer").stop()


func _on_hp_value_changed(value):
	if value <=0:
		dying = true
		var bloodcount = rng.randi_range(50,125)
		for i in bloodcount:
			var bloodspawn = blood.instantiate()
			bloodspawn.global_position = self.global_position
			get_parent().call_deferred("add_child", bloodspawn)
			bloodspawn.set_motion_noreflect(35,35)
		Game.gun_kill_counter += 1
		Game.grimm_gun_kill_counter += 1
		var luckgoldmod = 0 + (floor(Game.playerstats["Luck"] * 2.0))
		var coincount = rng.randi_range(25,50+luckgoldmod)
		for i in coincount:
			var coinspawn = coin.instantiate()
			var randxpos = rng.randi_range(-30,30)
			var randypos = rng.randi_range(-30,-20)
			coinspawn.global_position = self.global_position + Vector2(randxpos, randypos)
			get_parent().call_deferred("add_child", coinspawn)
			
		
		hpbar.visible = false
		patbar.visible = false
		alive_collision.disabled = true
		dead_collision.disabled = false
		get_node("Hitbox/CollisionShape2D").disabled = true
		get_node("Hitbox").monitoring = false
		
	else:
		frozen = false
		dead = false
		
func _on_patience_value_changed(value):
	if value <=0 and !berserk:
		nopatience = true
		Game.toy_kill_counter += 1
		Game.grimm_toy_kill_counter += 1
		var luckgoldmod = 0 + (floor(Game.playerstats["Luck"] * 2.0))
		var coincount = rng.randi_range(25,50+luckgoldmod)
		for i in coincount:
			var coinspawn = coin.instantiate()
			var randxpos = rng.randi_range(-30,30)
			var randypos = rng.randi_range(-30,-20)
			coinspawn.global_position = self.global_position + Vector2(randxpos, randypos)
			get_parent().call_deferred("add_child", coinspawn)
	if value <= 0 and Game.current_effects.has("Freeze-Ray (Toygun)") and frosted > 0:
		freeze()

func _on_attack_timer_timeout():
	hit = true




func _on_jumptimer_timeout():
	player_higher = true


func _on_repathtimer_timeout():
	repath = true

	


func _on_webstucktimer_timeout():
	webstuck = false


func _on_ally_timer_timeout():
	hypnotized = false
	hypnoimmune = true
	chase = true
	frogtarget = null
	get_node("AnimatedSprite2D").material.set_shader_parameter("new", Color.LIME_GREEN)
	attack_ready = false


func _on_hypnosphere_body_entered(body):
	hypno_nearby_enemies.append(body)


func _on_hypnosphere_body_exited(body):
	hypno_nearby_enemies.erase(body)


func _on_navigation_agent_2d_navigation_finished():
	if tutorial_area_2_cutscene_1:
		tutorial_area_2_cutscene_1 = false


func _on_tp_timer_timeout():
	var teleported
	if navi.get_final_position().y < (global_position.y - 40.0): #if player is higher
		teleported = false
	if dead or dying or nopatience or is_in_cutscene:
		teleported = true
	while !teleported:
		var playerpos = player.global_position
		var randx = rng.randi_range(-250,250)
		var randy = rng.randi_range(-150,150)
		navi.target_position = Vector2(playerpos.x + randx,playerpos.y + randy)
		if navi.is_target_reachable(): #if reachable
			var smokespawn = teleportpoof.instantiate()
			smokespawn.global_position = self.global_position
			get_parent().call_deferred("add_child", smokespawn)
			
			self.global_position = navi.target_position
			repathtimer.start()
			teleported = true


func _on_cast_timer_timeout():
	if dead or dying or nopatience or is_in_cutscene:
		pass
	else:
		casting = true
		casttimer.start()
		await get_tree().create_timer(1.0).timeout
		var enemychance = randf() - (Game.playerstats["Luck"] * 0.01)
		if enemychance > 0.6:
			var boospawn = boo.instantiate()
			var randposmod = Vector2(rng.randi_range(-250,250), rng.randi_range(-250,250))
			boospawn.global_position = self.global_position + randposmod
			boospawn.coindrops = false
			get_parent().call_deferred("add_child", boospawn)
		
		for i in range(5,20 - round((Game.playerstats["Luck"] * 0.25))):
			var bulletspawn = bullet.instantiate()
			bulletspawn.global_position = self.global_position
			var randdirmod = Vector2(rng.randi_range(-250,250), rng.randi_range(-250,250))
			bulletspawn.set_dir((randdirmod).normalized())
			get_parent().call_deferred("add_child", bulletspawn)
		
		casting = false
