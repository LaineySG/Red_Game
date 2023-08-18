extends StateMachine


func _ready():
	add_state("run")
	add_state("idle")
	add_state("crouch")
	add_state("crawl")
	add_state("slide")
	add_state("charging")
	add_state("gun")
	add_state("wallrun")
	add_state("fire")
	add_state("reload")
	add_state("dash")
	add_state("damage")
	add_state("death")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _input(_event):
	# Handle Jump.
	if Variables.inputIsDisabled:
		return
	else:
		#set_process_input(true)
		pass
		
		
	if Input.is_action_just_pressed("ui_accept") and parent.jumps > 0 and state != states.wallrun:
		if parent.velocity.y < -200.0:
			parent.velocity.y = -400.0
			parent.jumps -= 1 # doublejump
		else:
			parent.velocity.y = parent.JUMP_VELOCITY
			parent.jumps -= 1 # doublejump
		
	elif Input.is_action_just_pressed("ui_accept") and state == states.wallrun:
		parent.wallsidegravity(false)
		if parent.wall_jump_cooldown.is_stopped() and parent.wall_jump_cooldown2.is_stopped():
			parent.walljump()
	if Input.is_action_pressed("ui_left") and state == states.run and parent.direction == 1:
		parent.turning = true
	if Input.is_action_pressed("ui_right") and state == states.run and parent.direction == -1:
		parent.turning = true
	if Input.is_action_just_pressed("ui_Q") and state != states.fire and state != states.reload and Game.weapon_equipped != null and !Game.inventorylock:
		parent.switchgun(Input)
		parent.update_gun.emit()
		if Game.weapon_equipped == "gun" and state == states.gun:
			parent.anim.play("gun_idle")
		elif Game.weapon_equipped == "toygun" and state == states.gun:
			parent.anim.play("toygun_idle")
		
	var ability_pressed = null	
	
	if Input.is_action_just_pressed("ui_shift"):
		ability_pressed = parent.abilitykeys("ui_shift")
	elif Input.is_action_just_pressed("ui_R"):
		ability_pressed = parent.abilitykeys("ui_R")
	elif Input.is_action_just_pressed("ui_F"):
		ability_pressed = parent.abilitykeys("ui_F")
	elif Input.is_action_just_pressed("ui_1"):
		ability_pressed = parent.abilitykeys("ui_1")
	elif Input.is_action_just_pressed("ui_2"):
		ability_pressed = parent.abilitykeys("ui_2")
	elif Input.is_action_just_pressed("ui_3"):
		ability_pressed = parent.abilitykeys("ui_3")
	elif Input.is_action_just_pressed("ui_4"):
		ability_pressed = parent.abilitykeys("ui_4")
	elif Input.is_action_just_pressed("ui_5"):
		ability_pressed = parent.abilitykeys("ui_5")
	elif Input.is_action_just_pressed("ui_6"):
		ability_pressed = parent.abilitykeys("ui_6")
		
	if ability_pressed != null:
		if ability_pressed == "Dash" and parent.dash_CD.is_stopped():
			parent.dash()
			parent.dash_CD.start()
			var levelmodtest = (Game.current_abilities_levels["Dash"] / 5.0) + 0.4
			if Input.is_action_pressed("ui_left"):
				parent.velocity.x = -1500 * levelmodtest
				parent.velocity.y = -25
			elif Input.is_action_pressed("ui_right"):
				parent.velocity.x = 1500 * levelmodtest
				parent.velocity.y = -25
			elif state == states.gun or state == states.fire or state == states.reload:
				parent.velocity.x = 1500 * parent.currentdir * levelmodtest
				parent.velocity.y = -30
			else:
				parent.velocity.x = 1250 * parent.currentdir * levelmodtest
				parent.velocity.y = -25
		if ability_pressed == "Teleport" and parent.tele_CD.is_stopped():
			parent.teleport()
			parent.tele_CD.start()
			var levelmodtest = (Game.current_abilities_levels["Teleport"] / 5.0) + 0.4
			if Input.is_action_pressed("ui_left"):
				parent.velocity.x = -1750 * levelmodtest
				parent.velocity.y = -25
			elif Input.is_action_pressed("ui_right"):
				parent.velocity.x = 1750 * levelmodtest
				parent.velocity.y = -25
			else:
				parent.velocity.x = 1500 * parent.currentdir * levelmodtest
				parent.velocity.y = -25
		if ability_pressed == "Camoflague" and parent.camo_CD.is_stopped():
			parent.camoflague()
			parent.camo_CD.start()
		if ability_pressed == "Sprint" and parent.sprint_CD.is_stopped():
			parent.sprint()
			parent.sprint_CD.start()
		if ability_pressed == "Shield" and parent.shield_CD.is_stopped():
			parent.shield()
			parent.shield_CD.start()
		if ability_pressed == "Land Mine" and parent.mine_CD.is_stopped():
			parent.minespawn()
			parent.mine_CD.start()
		if ability_pressed == "Balloon" and parent.balloon_CD.is_stopped():
			parent.balloonspawn()
			parent.balloon_CD.start()
		if ability_pressed == "Summon(Green Aliens)" and parent.greenalien_CD.is_stopped():
			parent.greenalienspawn()
			parent.greenalien_CD.start()
		if ability_pressed == "Summon(CIA Drone)" and parent.drone_CD.is_stopped():
			parent.dronespawn()
			parent.drone_CD.start()
		

func _state_logic(delta):
	if state == states.death:
		parent._apply_gravity(delta)
	else:
		
		
		if state == states.gun:
			if Game.weapon_equipped == "gun":
				if parent.direction != 0:
					parent.anim.play("gun_idle_walk")
				else:
					parent.anim.play("gun_idle")
			elif Game.weapon_equipped == "toygun":
				if parent.direction != 0:
					parent.anim.play("toygun_idle_walk")
				else:
					parent.anim.play("toygun_idle")
		
		if state == states.wallrun:
			parent.wallsidegravity(true)
			parent._apply_movement(delta, 1)
			
		if state == states.crawl or state == states.crouch:
			parent._apply_movement(delta, 0.5)
		elif parent.dashing:
			parent._apply_movement(delta, 1.0)
		elif state == states.reload or state == states.charging or state == states.fire or state == states.gun:
			parent._gun_movement(delta)
			parent.move_and_slide()
		else:
			parent._apply_movement(delta, 1)
			
		if state == states.gun or state == states.fire or state == states.reload or state == states.charging:
			parent._draw_gun() # refresh gun dir
			
		parent._update_wall_direction()
		parent._update_move_direction()
		parent._apply_gravity(delta)
		
		if !parent.coyotetime:
			if parent.jumps > (parent.maxjumps - 1): # if they havent jumped yet
				parent.jumps -= 1 
			parent.coyotetime = true
	
	
func _get_transition(_delta):
	
	if Game.playerhp < 0:
		return states.death
	if (parent.dashing or parent.tping) and parent.dash_CD.is_stopped():
		return states.dash
	
	match state:
		states.idle:
			if parent.is_on_floor() == false:
				if parent.velocity.y < 16:   #negative is UP
					return states.jump
				elif parent.velocity.y > 16.5: # positive is DOWN
					return states.fall
			elif Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled:
				return states.crouch
			elif parent.velocity.x != 0: # if movement on x-axis
				return states.run
			elif parent.is_on_floor() and parent.item_reset_cooldown.is_stopped(): 
				if Input.is_action_pressed("ui_left_click") and !Game.inventorylock and !Variables.inputIsDisabled and Game.weapon_equipped != null:
					parent._gun_movement(_delta)
					parent._draw_gun()
					parent.item_reset_cooldown.start()
					if ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun"):
						return states.fire
					elif Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun":
						return states.charging
					elif !Game.inventorylock:
						parent.noammoclick.play()
						return states.reload
				elif (Input.is_action_just_pressed("ui_right_click") and !Variables.inputIsDisabled) and !Game.inventorylock and Game.weapon_equipped != null:
					return states.reload
		states.run:
			if parent.is_on_floor() == false:
				if parent.velocity.y < 16:   #negative is UP
					return states.jump
				elif parent.velocity.y > 16.5: # positive is DOWN
					return states.fall
			elif Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled:
				return states.crouch
			elif parent.velocity.x == 0: # if no x-axis motion
				return states.idle
			elif parent.is_on_floor() and parent.item_reset_cooldown.is_stopped(): 
				if Input.is_action_pressed("ui_left_click") and !Game.inventorylock and !Variables.inputIsDisabled and Game.weapon_equipped != null:
					parent.item_reset_cooldown.start()
					parent._draw_gun()
					if ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun"):
						return states.fire
					elif Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun":
						return states.charging
					elif !Game.inventorylock:
						parent.noammoclick.play()
						return states.reload
				elif (Input.is_action_just_pressed("ui_right_click") and !Variables.inputIsDisabled)and !Game.inventorylock and Game.weapon_equipped != null:
					return states.reload
		states.jump:
			if (parent.wall_direction == -1 and Input.is_action_pressed("ui_left")) or (parent.wall_direction == 1 and Input.is_action_pressed("ui_right")):
				return states.wallrun
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y > 16.5: # positive is DOWN
				return states.fall
		states.fall:
			if parent.wall_direction != 0:
				return states.wallrun
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 16:   #negative is UP
				return states.jump
		states.wallrun:
			if parent.is_on_floor() == false:
				if parent.wall_direction == 0:
					if parent.velocity.y < 16:   #negative is UP
						return states.jump
					elif parent.velocity.y > 16.5: # positive is DOWN
						return states.fall
			elif parent.is_on_floor() == true: # if no x-axis motion
				return states.idle
		states.crouch:
			if parent.is_on_floor() == false:
				if parent.velocity.y < 16:   #negative is UP
					return states.jump
				elif parent.velocity.y > 16.5: # positive is DOWN
					return states.fall
			elif parent.velocity.x != 0 and Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled: # if movement on x-axis and down press
				return states.crawl
			elif parent.velocity.x == 0 and !Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled:
				return states.idle
			elif Input.is_action_pressed("ui_left_click") and parent.is_on_floor() and parent.item_reset_cooldown.is_stopped() and !Game.inventorylock and !Variables.inputIsDisabled and Game.weapon_equipped != null:
				parent.item_reset_cooldown.start()
				parent._draw_gun()
				if ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun"):
					return states.fire
				elif Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun":
					return states.charging
				elif !Game.inventorylock:
					return states.reload
			elif (Input.is_action_just_pressed("ui_right_click") and !Variables.inputIsDisabled) and !Game.inventorylock and Game.weapon_equipped != null:
				return states.reload
		states.crawl:
			if parent.is_on_floor() == false:
				if parent.velocity.y < 16:   #negative is UP
					return states.jump
				elif parent.velocity.y > 16.5: # positive is DOWN
					return states.fall
			elif parent.velocity.x == 0 and Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled: # if still on x-axis and down press
				return states.crouch
			elif parent.velocity.x == 0 and !Input.is_action_pressed("ui_down"):
				return states.idle
			elif parent.velocity.x != 0 and !Input.is_action_pressed("ui_down"):
				return states.run
			elif Input.is_action_pressed("ui_left_click") and parent.is_on_floor() and parent.item_reset_cooldown.is_stopped() and !Game.inventorylock and Game.weapon_equipped != null:
				parent.item_reset_cooldown.start()
				parent._draw_gun()
				if ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun"):
					return states.fire
				elif Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun":
					return states.charging
				elif !Game.inventorylock:
					return states.reload
			elif (Input.is_action_just_pressed("ui_right_click") and !Variables.inputIsDisabled)and !Game.inventorylock and Game.weapon_equipped != null:
				return states.reload
		states.gun:
			if (Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and !Variables.inputIsDisabled:
				return states.run
			elif (Input.is_action_pressed("ui_right_click") and !Variables.inputIsDisabled) and !Game.inventorylock and Game.weapon_equipped != null:
				return states.reload
			elif (Input.is_action_pressed("ui_left_click")) and (Game.weapon_equipped == "gun" and Game.currentammo <= 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo <= 0) and !Game.inventorylock and !Variables.inputIsDisabled and Game.weapon_equipped != null:
				parent.noammoclick.play()
				return states.reload
			elif (Input.is_action_pressed("ui_left_click"))  and !Variables.inputIsDisabled and ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun") and Game.weapon_equipped != null:
				return states.fire
			elif (Input.is_action_pressed("ui_left_click")) and !Variables.inputIsDisabled and Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun" and Game.weapon_equipped != null:
				return states.charging
		states.reload: #similar to gun one
			if Input.is_action_pressed("ui_accept") and !Variables.inputIsDisabled and parent.item_reset_cooldown.is_stopped():
				return states.run
			elif (Game.weapon_equipped == "gun" and Game.currentammo == Game.ammomax) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo== Game.ammomax): #if times out reload
				return states.gun
			elif Input.is_action_pressed("ui_left_click") and !Variables.inputIsDisabled and ((Game.weapon_equipped == "gun" and Game.currentammo > 0) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo > 0)) and !Game.inventorylock and (!Game.current_effects.has("Pump-action (Toygun)") or !Game.weapon_equipped == "toygun") and Game.weapon_equipped != null:
				return states.fire
			elif Input.is_action_pressed("ui_left_click") and !Variables.inputIsDisabled and Game.currenttoyammo > 0 and !Game.inventorylock and Game.current_effects.has("Pump-action (Toygun)") and Game.weapon_equipped == "toygun" and Game.weapon_equipped != null:
				return states.charging
		states.fire:
			if parent.shotsfired:
				parent.shotsfired = false
				return states.gun
		states.charging:
			if !Input.is_action_pressed("ui_left_click") and !Variables.inputIsDisabled and Game.weapon_equipped != null:
				return states.fire
			if parent.chargetime >= 10.0:
				return states.fire
		states.dash:
			return states.idle
					
				
	return null

func _enter_state(new, previous):
	if parent.is_on_floor:
		get_node("sounds/in_air").stop()
	match new:
		states.death:
			if previous != states.death:
				parent.anim.play("death")
				Game.playerDied = true
		states.idle:
			parent.anim.play("idle")
			get_node("Label").text = "idle"
			parent.jumps = parent.maxjumps
		states.dash:
			parent.anim.play("run")
			get_node("Label").text = "dash"
		states.run:
			parent.jumps = parent.maxjumps
			get_node("sounds/running").play()
			if parent.turning == false:
				parent.anim.play("run")
			else:
				parent.anim.play("turn")
				await parent.anim.animation_finished
				parent.anim.play("run")
			get_node("Label").text = "run"
		states.reload:
			get_node("Label").text = "reloading"
			parent.shoot_torso.visible = true
			parent._draw_gun()
			
			var rng = RandomNumberGenerator.new()
			var reloadrandom = rng.randf() + (Game.playerstats["Reload Speed"] * 0.20/20)
			var reloadspeed = 1.0 + (Game.playerstats["Reload Speed"] * 0.5 / 20.0) 
			reloadspeed *= (1.0 + (Game.player_talents_current["Hyperactivity"] * 0.05))
			if reloadrandom > 0.66:
				if Game.weapon_equipped == "gun":
					if parent.direction == 0:
						parent.anim.play("reload",-1,reloadspeed)
					else:
						parent.anim.play("reload_walk",-1,reloadspeed)
				elif Game.weapon_equipped == "toygun":
					if parent.direction == 0:
						parent.anim.play("reload_toy",-1,reloadspeed)
					else:
						parent.anim.play("reload_toy_walk",-1,reloadspeed)
			elif reloadrandom > 0.33:
				if Game.weapon_equipped == "gun":
					if parent.direction == 0:
						parent.anim.play("reload_spinny",-1,reloadspeed)
					else:
						parent.anim.play("reload_spinny_walk",-1,reloadspeed)
				elif Game.weapon_equipped == "toygun":
					if parent.direction == 0:
						parent.anim.play("reload_spinny_toy",-1,reloadspeed)
					else:
						parent.anim.play("reload_spinny_toy_walk",-1,reloadspeed)
			else:
				if Game.weapon_equipped == "gun":
					if parent.direction == 0:
						parent.anim.play("reload_fumble",-1,reloadspeed)
					else:
						parent.anim.play("reload_fumble_walk",-1,reloadspeed)
					
				elif Game.weapon_equipped == "toygun":
					if parent.direction == 0:
						parent.anim.play("reload_fumble_toy",-1,reloadspeed)
					else:
						parent.anim.play("reload_fumble_toy_walk",-1,reloadspeed)
		states.jump:
			parent.anim.play("jump")
			get_node("sounds/in_air").play()
			get_node("Label").text = "jump"
			get_node("sounds/jump").play()
		states.fall:
			parent.anim.play("fall")
			get_node("Label").text = "fall"
			get_node("sounds/in_air").play()
			if previous != states.jump and previous != states.idle: #if previous state was on ground
				parent.coyote_time.start()
				parent.coyotetime = true
		states.wallrun:
			parent.anim.play("wallrun")
			get_node("sounds/wall_slide").play()
			get_node("Label").text = "wallrun"
			if parent.wall_direction == 1:
				parent.get_node("AnimatedSprite2D").flip_h = false
				parent.get_node("dustmaker_R").set_dust(true)
			elif parent.wall_direction == -1:
				parent.get_node("AnimatedSprite2D").flip_h = true
				parent.get_node("dustmaker_L").set_dust(true)
		states.gun:
			if Game.weapon_equipped == "gun":
				parent.anim.play("gun_idle")
			elif Game.weapon_equipped == "toygun":
				parent.anim.play("toygun_idle")
			get_node("Label").text = "gun"
			parent._draw_gun()
			parent.shoot_torso.visible = true
		states.fire:
			get_node("Label").text = "fire"
			parent.shoot_torso.visible = true
			parent._draw_gun()
			if Game.weapon_equipped == "gun" and !Game.inventorylock:
				var shotspeed = (1.0 + (Game.playerstats["Fire Rate"] * 0.8 / 20.0))
				if Game.current_effects.has("Berserk (Gun)"):
					var levelmodtest = (Game.current_effects_levels["Berserk (Gun)"] / 5.0) + 0.4
					shotspeed += Game.berserkshotcount * 0.1 * levelmodtest
					Game.berserkshotcount +=1
					parent.berserktimer.start()
				if Game.current_effects.has("Frenzy (Gun)"):
					var levelmodtest = (Game.current_effects_levels["Frenzy (Gun)"] / 5.0) + 0.4
					shotspeed += ((1.15 * (Game.playerhpmax - Game.playerhp) / Game.playerhpmax) * levelmodtest)
				if Game.current_effects.has("Flintlock (Gun)"):
					var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
					if shotspeed > 1.05:
						shotspeed *= 0.85 * levelmodtest
				parent.anim.play("shoot_recoil",0,shotspeed)
			elif Game.weapon_equipped == "toygun" and !Game.inventorylock:
				parent.anim.play("shoot_toy",0,(1.0 + (Game.playerstats["Fire Rate"] * 0.8 / 20.0)))
		states.crawl:
			parent.anim.play("crawl")
			get_node("Label").text = "crawl"
			parent._on_crouch()
		states.charging:
			get_node("Label").text = "charging"
			parent.shoot_torso.visible = true
			parent.anim.play("gun_charge")
		states.crouch:
			parent.anim.play("crouch")
			get_node("Label").text = "crouch"
			parent._on_crouch()
	if new == states.gun:
		parent.item_reset_cooldown.start()
	parent.turning = false
	
func _exit_state(previous, new):
	match previous:
		states.jump:
			if new != states.wallrun:
				get_node("sounds/in_air").stop()
		states.wallrun:
			parent.wall_jump_cooldown.start()
			parent.get_node("dustmaker_R").set_dust(false)
			parent.get_node("dustmaker_L").set_dust(false)
			get_node("sounds/wall_slide").stop()
			if parent.is_on_floor():
				parent.jumps = parent.maxjumps
				get_node("sounds/landing").play()
		states.crawl:
			parent._on_stand()
		states.crouch:
			parent._on_stand()
		states.gun:
			if new != states.reload and new != states.fire and new != states.charging:
				parent.item_reset_cooldown.start()
				parent._hide_gun()
				parent.shoot_torso.visible = false
		states.reload:
			if new != states.gun and new != states.fire:
				parent.shoot_torso.visible = false
				parent.get_node("Gunarms/GunarmR").visible = false
				parent.get_node("Gunarms/GunarmL").visible = false
			if (Game.weapon_equipped == "gun" and Game.currentammo != Game.ammomax) or (Game.weapon_equipped == "toygun" and Game.currenttoyammo != Game.ammomax):
				parent.cancelreloadaudio()
		states.fall:
			if new != states.jump and new != states.wallrun:
				parent.jumps = parent.maxjumps
				parent.poof()
				get_node("sounds/in_air").stop()
				get_node("sounds/landing").play()
			if new == states.wallrun:
				get_node("sounds/in_air").stop()
		states.dash:
			parent.item_reset_cooldown.start()
			parent._hide_gun()
			parent.shoot_torso.visible = false
		states.idle:
			#parent.jumps = parent.maxjumps
			parent.poof()
		states.run:
			get_node("sounds/running").stop()
			
