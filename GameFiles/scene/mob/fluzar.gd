extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("../../Player")
var wtf = preload("res://scene/mob/wtf.tscn")
var anger = preload("res://scene/mob/amgry.tscn")
var heart = preload("res://scene/mob/heart.tscn")
var slimeball = preload("res://scene/player/fluzar_projecitle.tscn")
var coin = preload("res://scene/item/coin.tscn")
var rng = RandomNumberGenerator.new()
@onready var alive_collision = $alive_shape
@onready var hover_ray = get_node("hover_ray")
@onready var dead_collision = $dead_shape
var chase = false
var dying = false
var frozen = false
var currentpos
var frogtarget
var webstuck = false
var tutorial_area_2_cutscene_1 = false
@onready var webstucktimer = $webstucktimer
var dead = false
var player_higher = false
var nopatience = false
var blood = preload("res://scene/mob/blood.tscn")
var berserk = false
var speedbase
var repath = false
var hypnotized = false
var hypnoimmune = false
var froststack = 0
var attackdamage = 15
var frosted = 0
var hit = false
@onready var anim = get_node("AnimatedSprite2D")

var speed = 85
var damage = 5
var health = 85
var patience = 75
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
@onready var jumptimer = $NavigationAgent2D/jumptimer
@onready var repathtimer = $NavigationAgent2D/repathtimer

func navigate():
	pass
	
func _ready():
	speedbase = speed
	currentpos = self.global_position
	hpbar.max_value = health
	hpbar.value = health
	patbar.max_value = patience
	patbar.value = patience
	
func _process(_delta):
	if !chase and !dead:
		velocity.y = -15
	if dead or dying:
		velocity.x = 0
	if player.camo and !dead and !dying and !frozen and !nopatience:
		velocity.y = -15
		velocity.x = 0
	if froststack > 0:
		speed = speedbase * pow(0.8,froststack)
#	if hover_ray.is_colliding():
#		if velocity.y > 0 and !dead:
#			velocity.y -= 80
	if self.position.x > 10000 or self.position.y > 10000:
		dead = true
	
			
func get_nav_path():
	if chase and !dying and !dead and !hypnotized and !player.camo:
		navi.target_position = player.global_position + Vector2(0,-50)
	if chase and !dying and !dead and hypnotized:
		if frogtarget == null:
			var cursor = 999999999.0
			for children in get_parent().get_children():
				if children.is_in_group("mob"):
					var currentdist = self.position.distance_to(children.position)
					if currentdist < cursor and children != self and !children.nopatience and !children.dead and !children.dying:
						frogtarget = children
						cursor = currentdist
				
			#get closest child
				
		if frogtarget != null:
			if frogtarget.name.left(6) != "fluzar" and frogtarget.name.left(7) != "@fluzar":
				navi.target_position = frogtarget.global_position + Vector2(0,-50)
			else:
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
	else:
		set_collision_layer_value(7,x)
#	get_node("Attackbox").set_collision_layer_value(7,x)
#	get_node("Hitbox").set_collision_layer_value(7,x)
#	get_node("Hitbox").set_collision_mask_value(7,x)

func apply_gravity(delta):
	move_and_slide()
	velocity.y += gravity * delta
	if nopatience and !frozen:
		velocity.y = 0
	if frozen:
		velocity.y += gravity * delta
		get_node("AnimatedSprite2D").modulate = Color(0.7,0.7,0.7,0.8)
	if player.camo: 
		velocity.y = 0
	
func _apply_movement(delta, nomove = false):
	if navi.is_navigation_finished():
		return
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
			get_node("Head").position.x *= -1
			get_node("dead_shape").position.x *= -1
	elif direction.x < 0 == true and player.camo == false:
		if !nomove and !webstuck:
			velocity.x = direction.x * speed
		get_node("AnimatedSprite2D").flip_h = false
		if get_node("Attackbox/CollisionShape2D").position.x > 0:
			get_node("Attackbox/CollisionShape2D").position.x *= -1
			get_node("Head").position.x *= -1
			get_node("dead_shape").position.x *= -1
	if frogtarget != null: 
		if !nomove and abs(frogtarget.position.x - self.position.x) < 10 and hypnotized: #if on top of frog enemy, move
			velocity.x = 0
	if direction.y < 0 and !player.camo: #player higher
		velocity.y = -speed
	if hypnotized and frogtarget != null:
		if frogtarget.nopatience:
			velocity.x = 0
			hypnotized = false
			hypnoimmune = true
			attack_ready = false
			chase = false
	if nopatience:
		velocity.y = 0
	if velocity.x > speedbase * 2:
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
	if on: # eg. if shot after nopatience
		set_collision_layer_value(7,true) # makes it interactible withable.
		set_collision_layer_value(10,false) # makes it interactible withable.
	elif !on: # false = no interactions
		set_collision_layer_value(7,false) # makes it uninteractible withable.
		set_collision_layer_value(10,true) # makes it interactible withable.

func _love():
	if !berserk and !frozen:
		var hearts = rng.randi_range(1,4)
		for i in hearts:
			var heartspawn = heart.instantiate()
			heartspawn.position = global_position + Vector2(rng.randi_range(-40,40),rng.randi_range(-40,40))
			get_parent().add_child(heartspawn)
			
func freeze():
	frozen = true
	
	
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
				dmg += 10
			nopatience = false
			velocity.x = -direction.x * 2000 * (Game.playerstats["Shot Weight"] * 1/20)
			
			if dmg > 5:
				var slimecount = rng.randi_range(4,8 - (Game.playerstats["Luck"] * 0.1))
				for i in slimecount:
					if !dead and !dying and !nopatience:
						var slimeballspawn = slimeball.instantiate()
						var randxpos = rng.randi_range(-30,30)
						var randypos = rng.randi_range(-30,-20)
						var randxvel = rng.randi_range(-150,150)
						var randyvel = rng.randi_range(-30,-20)
						slimeballspawn.global_position = self.global_position + Vector2(randxpos, randypos)
						slimeballspawn.velocity = Vector2(randxvel,randyvel)
						if hypnotized:
							slimeballspawn.hypnoset()
						slimeballspawn.setdamage(damage)
						get_parent().call_deferred("add_child", slimeballspawn)
			
		elif patiencedmg > 0 and !berserk and !dying and !dead and !frozen: # if shot w/ toy gun
			if patbar.value >= (patbar.max_value / 1.7) or patbar.value == 0: # over 60% ish or happy
				patbar.value -= patiencedmg
				var wtfspawn = wtf.instantiate()
				wtfspawn.position = get_node("Head").global_position
				get_parent().add_child(wtfspawn)
				if patiencedmg > 5:
					var slimecount = rng.randi_range(2,4)
					for i in slimecount:
						if !dead and !dying and !nopatience:
							var slimeballspawn = slimeball.instantiate()
							var randxpos = rng.randi_range(-30,30)
							var randypos = rng.randi_range(-30,-20)
							var randxvel = rng.randi_range(-150,150)
							var randyvel = rng.randi_range(-30,-20)
							slimeballspawn.global_position = self.global_position + Vector2(randxpos, randypos)
							slimeballspawn.velocity = Vector2(randxvel,randyvel)
							slimeballspawn.setdamage(damage)
							get_parent().call_deferred("add_child", slimeballspawn)
				
			elif !berserk: # under 50%
				patbar.value -= patiencedmg
				var angerspawn = anger.instantiate()
				angerspawn.position = get_node("Head").global_position
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
				if scale.x >= 0.6 or nopatience or dead or frozen:
					scale.x *= 0.95
					scale.y *= 0.95
					speed *= 0.90
				if damage > 1:
					damage -= (0.15 * damage)
				else:
					damage = 1
			var randchance = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
			if Game.current_effects.has("Web Shot (Toygun)") and randchance > 0.9:
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
			
		
		if Game.current_effects.has("Vampire (Gun)"):
			player.heal(0.1 * dmg)
		
func hypno():
	if !hypnoimmune:
		hypnotized = true
		attack_ready = false
		ally_timer.start()
		get_node("AnimatedSprite2D").material.set_shader_parameter("new", Color.HOT_PINK)
		get_node("Head/eyelight/Shadow").color = Color.HOT_PINK
		get_node("Head/eyelight/TextureLight").color = Color.HOT_PINK

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
		player.hurt(attackdamage,0)
	elif frogtarget != null and hypnotized:
		frogtarget.hurt(0,attackdamage/2.0,0,0)
		
func hypnoslow(_caster):
	#simulates fighting a hypnotized alien
	velocity.x = 0
	webstuck = true
	attack_ready = false
	webstucktimer.start()
	
	
		
func pierce():
	set_collision_layer_value(7,false) # makes it uninteractible withable.
	set_collision_layer_value(10,true) # makes it interactible withable.
	await get_tree().create_timer(0.25).timeout
	set_collision_layer_value(7,true) # makes it interactible withable.
	set_collision_layer_value(10,false) # makes it interactible withable.
		


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
		var luckgoldmod = 0 + (floor(Game.playerstats["Luck"] / 2.0))
		var coincount = rng.randi_range(1,4+luckgoldmod)
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
		get_node("Head/eyelight").visible = false
		get_node("Hitbox/CollisionShape2D").disabled = true
		get_node("Hitbox").monitoring = false
		
	else:
		frozen = false
		dead = false
		
func _on_patience_value_changed(value):
	if value <=0 and !berserk:
		nopatience = true
		Game.toy_kill_counter += 1		
		var luckgoldmod = 0 + (floor(Game.playerstats["Luck"] / 2.0))
		var coincount = rng.randi_range(1,4+luckgoldmod)
		for i in coincount:
			var coinspawn = coin.instantiate()
			var randxpos = rng.randi_range(-30,30)
			var randypos = rng.randi_range(-30,-20)
			coinspawn.global_position = self.global_position + Vector2(randxpos, randypos)
			get_parent().call_deferred("add_child", coinspawn)
	if value <= 0 and Game.current_effects.has("Freeze-Ray (Toygun)") and frosted > 0:
		freeze()

func _on_attack_timer_timeout():
	
	if hypnotized:
		get_node("Attackbox/AttackTimer").wait_time = 2.5 + rng.randf_range(-1.5,1.5)
	else:
		get_node("Attackbox/AttackTimer").wait_time = 6.0 + rng.randf_range(-2.0,2.0)
	
	var slimecount = rng.randi_range(5,12 - (Game.playerstats["Luck"] * 0.2))
	for i in slimecount:
		if !dead and !dying and !nopatience:
			var slimeballspawn = slimeball.instantiate()
			var randxpos = rng.randi_range(-30,30)
			var randypos = rng.randi_range(-30,-20)
			var randxvel = rng.randi_range(-150,150)
			var randyvel = rng.randi_range(-30,-20)
			slimeballspawn.global_position = self.global_position + Vector2(randxpos, randypos)
			slimeballspawn.velocity = Vector2(randxvel,randyvel)
			if hypnotized:
				slimeballspawn.hypnoset()
			slimeballspawn.setdamage(damage)
			get_parent().call_deferred("add_child", slimeballspawn)
		
		




func _on_jumptimer_timeout():
	player_higher = true


func _on_repathtimer_timeout():
	var newpos = self.global_position
	if abs((newpos.x - currentpos.x)) < 10 and !dead and !dying and !player.camo and chase and direction != null:
		navi.target_position = Vector2(global_position.x + (-direction.x * 50),global_position.y + (-direction.y * 50))
		velocity *= 5
	currentpos = newpos
	pass
		
	

	


func _on_webstucktimer_timeout():
	webstuck = false


func _on_ally_timer_timeout():
	hypnotized = false
	hypnoimmune = true
	chase = true
	frogtarget = null
	get_node("AnimatedSprite2D").material.set_shader_parameter("new", Color.DARK_SLATE_GRAY)
	get_node("Head/eyelight/Shadow").color = Color.DARK_SLATE_GRAY
	get_node("Head/eyelight/TextureLight").color = Color.DARK_SLATE_GRAY
	attack_ready = false


func _on_hypnosphere_body_entered(body):
	hypno_nearby_enemies.append(body)


func _on_hypnosphere_body_exited(body):
	hypno_nearby_enemies.erase(body)


func _on_navigation_agent_2d_navigation_finished():
	if tutorial_area_2_cutscene_1:
		tutorial_area_2_cutscene_1 = false


func _on_hp_hitbox_overlapping(count):
	get_node("hp").position.y = (-44) - (10 * count)
	get_node("patience").position.y = (-40) - (10 * count)

func _on_attackbox_body_entered(body):
	if body.name == "Player" and nopatience:
		_love()
