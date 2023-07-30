extends CharacterBody2D

################################################################################
#VARIABLES#
################################################################################
var JUMP_VELOCITY = -300.0
var currentdir = 0
const crouchspeed = 0.8
var wtf = preload("res://scene/mob/wtf.tscn")
var direction
var coyotetime = true
@export var jumps = 2
@export var maxjumps = 2
@export var chargetime = 0.0
var turning = false
var prev_wall_dir
var shotsfired = false
var currentDoTs = 0
var accuracy = 100 # out of 200 
var dashing = false
var tping = false
var camo = false
var shielded = false
var sprinting = false
var SPEED = 300.0
var iframes = false
var rng = RandomNumberGenerator.new()
var wallside_gravity_fall_speed = 0.50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
var bullet = preload("res://scene/player/bullet.tscn")
var dust = preload("res://scene/item/dust.tscn")
var toybullet = preload("res://scene/player/toybullet.tscn")
var greenalien = preload("res://scene/item/green_alien.tscn")
var drone = preload("res://scene/item/govt_drone.tscn")
var balloon = preload("res://scene/item/balloon.tscn")
var mine = preload("res://scene/item/mine.tscn")
var heartshot = preload("res://scene/player/heartshot.tscn")
var hypnoray = preload("res://scene/player/hypnoshot.tscn")
var shell = preload("res://scene/player/shell.tscn")
@onready var shoot_torso = get_node("shoot_body_torso")
signal update_health
signal update_ammo
signal update_gun
@onready var wall_jump_cooldown = $timers/Walljumptimer
@onready var noammoclick = $Gunarms/no_ammo_click
@onready var wall_jump_cooldown2 = $timers/Walljumptimer2
@onready var dash_CD = $timers/dash_CD
@onready var tele_CD = $timers/tele_CD
@onready var shield_CD = $timers/shield_CD
@onready var iframetimer = $timers/iframes
@onready var balloon_CD = $timers/balloon_CD
@onready var mine_CD = $timers/mine_CD
@onready var sprint_CD = $timers/sprint_CD
@onready var camo_CD = $timers/camo_CD
@onready var greenalien_CD = $timers/greenalien_CD
@onready var drone_CD = $timers/drone_CD
@onready var wall_stick_cooldown = $timers/Wallsticktimer
@onready var coyote_time = $timers/Coyotetime
@onready var item_reset_cooldown = $timers/Itemresettimer
@onready var berserktimer = $timers/berserktimer
@onready var shoot_cooldown = $timers/Shoottimer

#For collision boxes
@onready var stand_collision = $Standing
@onready var crouch_collision = $Crouching
@onready var slide_collision = $Sliding

#wall sliding 
@onready var left_wall_raycasts = $WallRayCasts/LeftWallRayCasts
@onready var right_wall_raycasts = $WallRayCasts/RightWallRayCasts
var wall_direction = 1


################################################################################
#MOTION#
################################################################################
func _apply_gravity(delta):
	velocity.y += gravity * delta #gravity
	if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		velocity.x = move_toward(velocity.x,0,delta * SPEED)
	
func _ready():
	SaveAndLoad.savegame(get_tree().current_scene,1)  # slot 1 - autosave
	update_ammo.emit()
	update_gun.emit()
	update_health.emit()
	get_node("Gunarms/GunarmL/gun/GunFlashL").visible = false
	get_node("Gunarms/GunarmR/gun/GunFlashR").visible = false
	await get_tree().create_timer(0.2).timeout
	jumps = maxjumps
	resetshaders()
	
	for children in get_node("timers").get_children():
		if children.name.right(3) == "_CD":
			if Game.abilityCDs.has(children.name):
				children.start(Game.abilityCDs[children.name])
				

func _process(_delta):
	if !iframes:
		get_node("shoot_body_torso").material.set_shader_parameter("enable_sil",0)
		get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_sil",0)
		get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_sil",0)
	
	if Game.playerhp <= 0: # death
		velocity.x = 0
		get_node("shoot_body_torso").visible = false
		get_node("Gunarms/GunarmL").visible = false
		get_node("Gunarms/GunarmR").visible = false
		anim.play("death")
		await anim.animation_finished
		Game.playerDied = true
		_hide_gun()
	if sprinting:	
		SPEED = 500.0 + (Game.playerstats["Alacrity"] * 5)
		JUMP_VELOCITY = -400.0 + (Game.playerstats["Alacrity"] * -5)
	else:
		SPEED = 300.0 + (Game.playerstats["Alacrity"] * 5)
		JUMP_VELOCITY = -300.0 + (Game.playerstats["Alacrity"] * -5)
		
	dash_CD.wait_time = 2.5 - (Game.playerstats["Alacrity"] * 2.5 * 0.03)
	tele_CD.wait_time = 12.0 - (Game.playerstats["Alacrity"] * 12.0 * 0.03)
	sprint_CD.wait_time = 30.0 - (Game.playerstats["Alacrity"] * 30.0 * 0.03)
	shield_CD.wait_time = 180.0 - (Game.playerstats["Alacrity"] * 180.0 * 0.03)
	camo_CD.wait_time = 60.0 - (Game.playerstats["Alacrity"] * 60.0 * 0.03)
	mine_CD.wait_time = 45.0 - (Game.playerstats["Alacrity"] * 45.0 * 0.03)
	balloon_CD.wait_time = 45.0 - (Game.playerstats["Alacrity"] * 45.0 * 0.03)
	greenalien_CD.wait_time = 180.0 - (Game.playerstats["Alacrity"] * 180.0 * 0.03)
	drone_CD.wait_time = 165.0 - (Game.playerstats["Alacrity"] * 165.0 * 0.03)
	iframetimer.wait_time = 0.35 + (Game.playerstats["Alacrity"] * 0.01)
	
	for children in get_node("timers").get_children():
		if children.name.right(3) == "_CD" and children.time_left >= 1.0:
			Game.abilityCDs[children.name] = children.time_left
			

func abilitykeys(key_pressed):
	for ability in Game.current_abilities:
		var keypress = Game.current_abilities[ability]
		if keypress == "S":
			if key_pressed == "ui_shift" and !Game.inventorylock:
				return ability
		elif keypress == "R":
			if key_pressed == "ui_R":
				return ability
		elif keypress == "F":
			if key_pressed == "ui_F":
				return ability
		else:
			if key_pressed == ("ui_" + str(keypress)):
				return ability
	return
	
func poof():
	var dustspawn = dust.instantiate()
	dustspawn.position = global_position
	get_parent().add_child(dustspawn)
		

func _update_move_direction():
	if !Variables.inputIsDisabled and !Game.playerDied:
		direction = Input.get_axis("ui_left", "ui_right")
	else:
		direction = 0

func wallsidegravity(x):
	if x and wall_stick_cooldown.is_stopped():
		if Input.is_action_pressed("ui_down") and !Variables.inputIsDisabled:
			velocity.y -= velocity.y * 0.05
		else:
			velocity.y -= velocity.y * 0.30

func walljump():
	wall_stick_cooldown.start()
	if wall_jump_cooldown.is_stopped() and wall_jump_cooldown2.is_stopped():
		velocity.x = JUMP_VELOCITY * wall_direction * 2.2
		velocity.y = JUMP_VELOCITY * 1.1
		wall_jump_cooldown.start()

# Handles crouch
func _apply_movement(_delta, speed_mod):
	# Get the input direction and handle the movement/deceleration.
	#Flips sprite to correct direction
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		get_node("shoot_body_torso").flip_h = true
		currentdir = -1
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		get_node("shoot_body_torso").flip_h = false
		currentdir = 1
	#Movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED * speed_mod, _delta * SPEED*10)
	else:
		velocity.x = move_toward(velocity.x, 0, _delta * SPEED*10)
	move_and_slide()
	
func teleport():
	tping = true
	iframes = true
	set_collision_layer_value(5,false) # makes it uninteractible withable.
	
	
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_disintegrate",1)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_disintegrate",1)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_disintegrate",1)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_disintegrate",1)
	get_node("AnimatedSprite2D").material.set_shader_parameter("amount", 5)
	await get_tree().create_timer(0.3).timeout
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_disintegrate",0)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_disintegrate",0)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_disintegrate",0)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_disintegrate",0)
	iframes = false
	tping=false
	
	set_collision_layer_value(5,true) # makes it uninteractible withable.
	
	
func balloonspawn():
	var spawn = balloon.instantiate()
	get_parent().add_child(spawn)
	spawn.global_position = self.global_position
	
	
func greenalienspawn():
	var spawn = greenalien.instantiate()
	get_parent().add_child(spawn)
	spawn.global_position = self.global_position
	
func dronespawn():
	var spawn = drone.instantiate()
	get_parent().add_child(spawn)
	spawn.global_position = self.global_position
	
func minespawn():
	var spawn = mine.instantiate()
	get_parent().add_child(spawn)
	spawn.global_position = self.global_position

func camoflague():
	camo = true
	
	#set_collision_layer_value(5,false) # makes it uninteractible withable.
	
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_blur",1)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_blur",1)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_blur",1)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_blur",1)
	get_node("AnimatedSprite2D").modulate = Color(0.5,1.0,0.5,0.5)
	get_node("shoot_body_torso").modulate = Color(0.5,1.0,0.5,0.5)
	get_node("Gunarms/GunarmL/gun").modulate = Color(0.5,1.0,0.5,0.5)
	get_node("Gunarms/GunarmR/gun").modulate = Color(0.5,1.0,0.5,0.5)
	var levelmodtest = (Game.current_abilities_levels["Camoflague"] / 5.0) + 0.6
	var time = 5.0 * levelmodtest	
	await get_tree().create_timer(time).timeout
	if camo:
		uncamoflague()
	#set_collision_layer_value(5,true) # makes it uninteractible withable
	
func uncamoflague():
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_blur",0)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_blur",0)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_blur",0)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_blur",0)
	get_node("AnimatedSprite2D").modulate = Color(1.0,1.0,1.0,1.0)
	get_node("shoot_body_torso").modulate = Color(1.0,1.0,1.0,1.0)
	get_node("Gunarms/GunarmL/gun").modulate = Color(1.0,1.0,1.0,1.0)
	get_node("Gunarms/GunarmR/gun").modulate = Color(1.0,1.0,1.0,1.0)
	camo = false
	
func shield():
	shielded = true
	
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_outline",1)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_outline",1)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_outline",1)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_outline",1)
	get_node("AnimatedSprite2D").material.set_shader_parameter("outline_width",0.35)
	get_node("shoot_body_torso").material.set_shader_parameter("outline_width",0.35)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("outline_width",0.35)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("outline_width",0.35)
	get_node("AnimatedSprite2D").material.set_shader_parameter("outline_color",Color8(22,125,230,140))
	get_node("shoot_body_torso").material.set_shader_parameter("outline_color",Color8(22,125,230,140))
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("outline_color",Color8(22,125,230,140))
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("outline_color",Color8(22,125,230,140))
	var levelmodtest = (Game.current_abilities_levels["Shield"] / 5.0) + 0.6
	var time = 5.0 * levelmodtest	
	await get_tree().create_timer(time).timeout
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_outline",0)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_outline",0)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_outline",0)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_outline",0)
	
	shielded = false
	
	
func sprint():
	sprinting = true
	#get_node("AnimatedSprite2D").material.set_shader_parameter("enable_blur",1)
	var levelmodtest = (Game.current_abilities_levels["Sprint"] / 5.0) + 0.6
	SPEED += (200.0 * levelmodtest)
	JUMP_VELOCITY -= (100.0 * levelmodtest)
	if anim.current_animation == "run":
		anim.play("run", 0.0, 1.5)
		
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_offset_shadow",1)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_offset_shadow",1)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_offset_shadow",1)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_offset_shadow",1)
	get_node("AnimatedSprite2D").material.set_shader_parameter("offset_shadow_modulate", Color8(36,81,49,150))
	get_node("shoot_body_torso").material.set_shader_parameter("offset_shadow_modulate", Color8(36,81,49,150))
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("offset_shadow_modulate", Color8(36,81,49,150))
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("offset_shadow_modulate", Color8(36,81,49,150))
	if currentdir == -1: #Color8(237,47,255,150)   (36,81,49,150)
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("shoot_body_torso").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("offset", Vector2(2,-2))
	elif currentdir == 1:
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("shoot_body_torso").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("offset", Vector2(2,-2))
		get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("offset", Vector2(2,-2))
	else:
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(-2,-2))
		get_node("shoot_body_torso").material.set_shader_parameter("offset", Vector2(-2,-2))
		get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("offset", Vector2(-2,-2))
		get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("offset", Vector2(-2,-2))
	await get_tree().create_timer(3).timeout
	get_node("AnimatedSprite2D").material.set_shader_parameter("offset_shadow_modulate", Color8(0,0,0,0))
	get_node("shoot_body_torso").material.set_shader_parameter("offset_shadow_modulate", Color8(0,0,0,0))
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("offset_shadow_modulate", Color8(0,0,0,0))
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("offset_shadow_modulate", Color8(0,0,0,0))
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_offset_shadow",0)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_offset_shadow",0)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_offset_shadow",0)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_offset_shadow",0)
	
	if anim.current_animation == "run":
		anim.play("run", 0.0, 1.0)
	SPEED -= (200.0 * levelmodtest)
	JUMP_VELOCITY += (100.0 * levelmodtest)
	#get_node("AnimatedSprite2D").material.set_shader_parameter("enable_blur",0)
	sprinting = false
	
func heal(x):
	var crit_heal = false
	if (rng.randf() + (0.02 * Game.playerstats["Luck"])) > 0.99 :
		#critical heal
		crit_heal = true
		x = x * 2.0
	Game.playerhp += x
	update_health.emit(	)
	
	if Game.playerhp < Game.playerhpmax and (x > 1):
		var healnumspawn = wtf.instantiate()
		var locationmodx = rng.randi_range(-50,50)
		healnumspawn.position = global_position
		healnumspawn.position.x += locationmodx
		healnumspawn.position.y -= 50
		healnumspawn.settext(str(round(x)))
		if crit_heal:
			healnumspawn.scale = Vector2(1.5,1.5)
			healnumspawn.settext(str(round(x)))
			healnumspawn.setcolor(Color.GOLD)
		else:
			healnumspawn.modulate = Color.GREEN
		get_parent().add_child(healnumspawn)
	
func dash():
	dashing = true
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_offset_shadow",1)
	get_node("AnimatedSprite2D").material.set_shader_parameter("offset_shadow_modulate", Color8(245,22,10,150))
	if currentdir == -1 and !get_node("timers/Shoottimer").is_stopped(): #Color8(237,47,255,150)   (36,81,49,150)
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(2,-2))
	elif currentdir == 1 and !get_node("timers/Shoottimer").is_stopped():
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(2,-2))
	else:
		get_node("AnimatedSprite2D").material.set_shader_parameter("offset", Vector2(-2,-2))
	await get_tree().create_timer(0.3).timeout
	get_node("AnimatedSprite2D").material.set_shader_parameter("offset_shadow_modulate", Color8(0,0,0,0))
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_offset_shadow",0)
	dashing = false
	
func _gun_movement(_delta):
	if get_global_mouse_position().x > global_position.x && get_node("AnimatedSprite2D").flip_h == true:
		get_node("AnimatedSprite2D").flip_h = false
		get_node("shoot_body_torso").flip_h = false
		currentdir = -1
	elif get_global_mouse_position().x < global_position.x && get_node("AnimatedSprite2D").flip_h == false:
		get_node("AnimatedSprite2D").flip_h = true
		get_node("shoot_body_torso").flip_h = true
		currentdir = 1
	#Movement
	if direction:
		velocity.x = direction * SPEED * 0.05
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func hurt(x,DoT):
	if !shielded and !iframes:
		Game.playerhp -= x
		update_health.emit(	)
		if x > 5:
			iframes = true
			get_node("AnimatedSprite2D").material.set_shader_parameter("enable_sil",1)
			get_node("shoot_body_torso").material.set_shader_parameter("enable_sil",1)
			get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_sil",1)
			get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_sil",1)
			iframetimer.start()
	if DoT > 0 and !iframes and !shielded:
		afflictDoT(DoT)
	
func afflictDoT(DoT):
	currentDoTs += 1
	$timers/dottimer.start()
	await get_tree().create_timer(1.0).timeout
	var ouchie = get_tree().create_tween()
	ouchie.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie.finished
	var returner = get_tree().create_tween()
	returner.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,0)
	await get_tree().create_timer(1.0).timeout
	var ouchie2 = get_tree().create_tween()
	ouchie2.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie2.finished
	var returner2 = get_tree().create_tween()
	returner2.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,0)
	await get_tree().create_timer(1.0).timeout
	var ouchie3 = get_tree().create_tween()
	ouchie3.tween_property(self,"modulate", Color.RED, 0.2)
	await ouchie3.finished
	var returner3 = get_tree().create_tween()
	returner3.tween_property(self,"modulate", Color.WHITE, 0.2)
	hurt(DoT,0)
	currentDoTs -= 1
	
func bounce():
	velocity.y = JUMP_VELOCITY
	
func _on_crouch():
	stand_collision.disabled = true
	crouch_collision.disabled = false
	
func _draw_gun():
	update_ammo.emit()
	if get_node("AnimatedSprite2D").flip_h: # if char is flipped left
		get_node("Gunarms/GunarmR").visible = false
		get_node("Gunarms/GunarmL").visible = true
		currentdir = 1
	else: # if char is facing 
		get_node("Gunarms/GunarmR").visible = true
		get_node("Gunarms/GunarmL").visible = false
		currentdir = -1
		
func _hide_gun():
	update_ammo.emit()
	get_node("Gunarms/GunarmR").visible = false
	get_node("Gunarms/GunarmL").visible = false
	
	
func _on_stand():
	stand_collision.disabled = false
	crouch_collision.disabled = true
	
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 and dot < PI * 0.55:
				return true
	return false
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	
	if is_near_wall_left and is_near_wall_right:
		wall_direction = direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	if wall_direction != prev_wall_dir and wall_direction != 0:
		wall_jump_cooldown.stop()
		wall_jump_cooldown2.start()
	if wall_direction != 0:
		prev_wall_dir = wall_direction
		

func _reload():
	if Game.weapon_equipped == "gun":
		Game.currentammo = (int(round(Game.playerstats["Magazine Size"] * 14 / 20))) + 7
	elif Game.weapon_equipped == "toygun":
		Game.currenttoyammo = (int(round(Game.playerstats["Magazine Size"] * 14 / 20))) + 7
	update_ammo.emit()

func _shoot(_shootoverride=false):
		shoot_cooldown.start() # Used for dash effects
		accuracy =  100 + (int(Game.playerstats.get("Scope") * 5))
		var knockbackmod = 0
		var numShots = 1
		
		if camo:
			uncamoflague()
		
		if Game.current_effects.has("Duo-Shot"):
			numShots *= 2
		if Game.current_effects.has("Tri-Shot"):
			numShots *= 3
		if Game.current_effects.has("Quad-Shot"):
			numShots *= 4
		if !Game.inventorylock:
			if Game.weapon_equipped == "gun":
				Game.currentammo -= 1
			elif Game.weapon_equipped == "toygun":
				Game.currenttoyammo -= 1
			update_ammo.emit()
			if get_node("Gunarms/GunarmR").visible == true:
				if Game.weapon_equipped == "gun":
					knockbackmod = -350
					knockbackmod += (Game.playerstats["Bullet Size"] / 20 * -150)
					knockbackmod += (Game.playerstats["Shot Weight"] / 20 * -150)
					if Game.current_effects.has("Big-Shot"):
						var levelmodtest = (Game.current_effects_levels["Big-Shot"] / 5.0) + 0.4
						knockbackmod += -250 * levelmodtest
					if Game.current_effects.has("Flintlock (Gun)"):
						var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
						knockbackmod += -200 * levelmodtest
					knockbackmod += (numShots - 1) * -50
					get_node("Camera2D").add_trauma(0.1 + (knockbackmod / -2000 * 0.3))
					velocity.x = knockbackmod
					move_and_slide()
					var randchance = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
					if Game.current_effects.has("Poison Spray (Gun)") and randchance > 0.85:
						for i in numShots:
							get_node("Gunarms/poison_spray").emitall(self.global_position)
							var fetti = get_node("Gunarms/GunarmR/gun/confetti_dmg").duplicate()
							var levelmodtest = (Game.current_effects_levels["Poison Spray (Gun)"] / 5.0) + 0.4
							fetti.setdmg(0,( (5 + (Game.playerstats["Punch"] * 2)) * levelmodtest),(( 0.4 + (Game.playerstats["Punch"] * 0.1) * levelmodtest)),0)
							get_node("Gunarms/Confettichildren").add_child(fetti)
							fetti.init(self.global_position)
							fetti.visible = true
					else:
						for i in numShots:
							var spawn = bullet.instantiate()
							get_parent().add_child(spawn)
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmR/gun/RBulletSpawn").global_position,accuracy)
					var shellspawn = shell.instantiate()
					shellspawn.position = get_node("Gunarms/GunarmR/gun/RShellSpawn").global_position
					var rand = rng.randi_range(-75,75)
					shellspawn.linear_velocity.y = -50
					shellspawn.linear_velocity.x = rand
					get_parent().add_child(shellspawn)
					await anim.animation_finished
					anim.play("gun_idle")
					
				elif Game.weapon_equipped == "toygun":
					knockbackmod = 0
					knockbackmod += (Game.playerstats["Bullet Size"] / 20 * -25)
					knockbackmod += (Game.playerstats["Shot Weight"] / 20 * -25)
					if Game.current_effects.has("Big-Shot"):
						var levelmodtest = (Game.current_effects_levels["Big-Shot"] / 5.0) + 0.4
						knockbackmod += -100 * levelmodtest
					knockbackmod += (numShots - 1) * -10
					get_node("Camera2D").add_trauma(0.15 * knockbackmod / 270)
					velocity.x = knockbackmod
					move_and_slide()
					var rand = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
					var cutoff2
					var cutoff
					if Game.current_effects.has("Confetti Cannon (Toygun)") and Game.current_effects.has("Hypno-Ray (Toygun)"):
						cutoff2 = 0.70
						cutoff = 0.85
					else:
						cutoff2 = 0.85
						cutoff = 0.85
					if Game.current_effects.has("Confetti Cannon (Toygun)") and rand > cutoff:
						for i in numShots:
							get_node("Gunarms/confetti_cannon").emitall(self.global_position)
							var fetti = get_node("Gunarms/GunarmR/gun/confetti_dmg").duplicate()
							var levelmodtest = (Game.current_effects_levels["Confetti Cannon (Toygun)"] / 5.0) + 0.4
							var fettidmg = (2.0 + (Game.playerstats["Punch"] * 3)) * levelmodtest
							var fettidot = (0.2 + (Game.playerstats["Punch"] * 0.2)) * levelmodtest
							fetti.setdmg(fettidmg,0,0,fettidot)
							get_node("Gunarms/Confettichildren").add_child(fetti)
							if Game.current_effects.has("Pump-action (Toygun)"):
								levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								fetti.Chargemod(chargetime * levelmodtest)
								chargetime = 0.0
							fetti.init(self.global_position)
							fetti.visible = true
					elif Game.current_effects.has("Hypno-Ray (Toygun)") and rand > cutoff2:
						for i in numShots:
							var spawn = hypnoray.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								chargetime = 0.0
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmR/gun/RBulletSpawn").global_position,accuracy)
					elif Game.current_effects.has("Heart-Shot (Toygun)"):
						for i in numShots:
							var spawn = heartshot.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmR/gun/RBulletSpawn").global_position,accuracy)
					else:
						for i in numShots:
							var spawn = toybullet.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmR/gun/RBulletSpawn").global_position,accuracy)
					chargetime = 0.0
					await anim.animation_finished
					anim.play("toygun_idle")
		
				
			elif get_node("Gunarms/GunarmL").visible == true:
				if Game.weapon_equipped == "gun":
					knockbackmod = 350
					knockbackmod += (Game.playerstats["Bullet Size"] / 20 * 150)
					knockbackmod += (Game.playerstats["Shot Weight"] / 20 * 150)
					if Game.current_effects.has("Big-Shot"):
						var levelmodtest = (Game.current_effects_levels["Big-Shot"] / 5.0) + 0.4
						knockbackmod += 250 * levelmodtest
					if Game.current_effects.has("Flintlock (Gun)"):
						var levelmodtest = (Game.current_effects_levels["Flintlock (Gun)"] / 5.0) + 0.4
						knockbackmod += 200 * levelmodtest
					knockbackmod += (numShots - 1) * 50
					get_node("Camera2D").add_trauma(0.1 + (knockbackmod / 2000 * 0.3))
					velocity.x = knockbackmod
					move_and_slide()
					var randchance = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
					if Game.current_effects.has("Poison Spray (Gun)") and randchance > 0.85:
						for i in numShots:
							get_node("Gunarms/poison_spray").emitall(self.global_position)
							var fetti = get_node("Gunarms/GunarmL/gun/confetti_dmg").duplicate()
							var levelmodtest = (Game.current_effects_levels["Poison Spray (Gun)"] / 5.0) + 0.4
							fetti.setdmg(0,( (5 + (Game.playerstats["Punch"] * 2)) * levelmodtest),(( 0.4 + (Game.playerstats["Punch"] * 0.1) * levelmodtest)),0)
							get_node("Gunarms/Confettichildren").add_child(fetti)
							fetti.init(self.global_position)
							fetti.visible = true
					else:
						for i in numShots:
							var spawn = bullet.instantiate()
							get_parent().add_child(spawn)
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmL/gun/LBulletSpawn").global_position,accuracy)
					var shellspawn = shell.instantiate()
					shellspawn.position = get_node("Gunarms/GunarmL/gun/LShellSpawn").global_position
					var rand = rng.randi_range(-75,75)
					shellspawn.linear_velocity.y = -50
					shellspawn.linear_velocity.x = rand
					get_parent().add_child(shellspawn)
					await anim.animation_finished
					anim.play("gun_idle")
					
				elif Game.weapon_equipped == "toygun":
					knockbackmod = 0
					knockbackmod += (Game.playerstats["Bullet Size"] / 20 * 25)
					knockbackmod += (Game.playerstats["Shot Weight"] / 20 * 25)
					if Game.current_effects.has("Big-Shot"):
						var levelmodtest = (Game.current_effects_levels["Big-Shot"] / 5.0) + 0.4
						knockbackmod += 100 * levelmodtest
					knockbackmod += (numShots - 1) * 10
					velocity.x = knockbackmod
					get_node("Camera2D").add_trauma(0.15 * knockbackmod / 270)
					move_and_slide()
					var rand = (rng.randf() + (0.02 * Game.playerstats["Luck"]))
					var cutoff2
					var cutoff
					if Game.current_effects.has("Confetti Cannon (Toygun)") and Game.current_effects.has("Hypno-Ray (Toygun)"):
						cutoff2 = 0.70 
						cutoff = 0.85
					else:
						cutoff2 = 0.85
						cutoff = 0.85
					if Game.current_effects.has("Confetti Cannon (Toygun)") and rand > cutoff:
						for i in numShots:
							get_node("Gunarms/confetti_cannon").emitall(self.global_position)
							var fetti = get_node("Gunarms/GunarmL/gun/confetti_dmg").duplicate()
							var levelmodtest = (Game.current_effects_levels["Confetti Cannon (Toygun)"] / 5.0) + 0.4
							var fettidmg = (2.0 + (Game.playerstats["Punch"] * 3)) * levelmodtest
							var fettidot = (0.2 + (Game.playerstats["Punch"] * 0.2)) * levelmodtest
							fetti.setdmg(fettidmg,0,0,fettidot)
							get_node("Gunarms/Confettichildren").add_child(fetti)
							if Game.current_effects.has("Pump-action (Toygun)"):
								levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								fetti.Chargemod(chargetime * levelmodtest)
							fetti.init(self.global_position)
							fetti.visible = true
					elif Game.current_effects.has("Hypno-Ray (Toygun)") and rand > cutoff2:
						for i in numShots:
							var spawn = hypnoray.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmL/gun/LBulletSpawn").global_position,accuracy)
					elif Game.current_effects.has("Heart-Shot (Toygun)"):
						for i in numShots:
							var spawn = heartshot.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmR/gun/RBulletSpawn").global_position,accuracy)
					else:
						for i in numShots:
							var spawn = toybullet.instantiate()
							get_parent().add_child(spawn)
							if Game.current_effects.has("Pump-action (Toygun)"):
								var levelmodtest = (Game.current_effects_levels["Pump-action (Toygun)"] / 5.0) + 0.4
								spawn.mischief *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
								spawn.MoT *=  (1.0 + ( 0.12 * chargetime)) * levelmodtest
							spawn.shoot_at_mouse(get_node("Gunarms/GunarmL/gun/LBulletSpawn").global_position,accuracy)
					chargetime = 0.0
					await anim.animation_finished
					anim.play("toygun_idle")
			
		
func switchgun(_input):
	if Game.weapon_equipped == null:
		return
	
	if Game.weapon_equipped == Game.gun_list[0]:
		if Game.gun_list.size() > 1:
			Game.weapon_equipped = Game.gun_list[1]
	else:
		#if Game.gun_list.size() > 1:
			Game.weapon_equipped = Game.gun_list[0]
	update_gun.emit()
	update_ammo.emit()
		
	#if Game.weapon_equipped == "gun":
		#anim.play("gun_idle")
	#elif Game.weapon_equipped == "toygun":
		#anim.play("toygun_idle")
		



func _on_coyotetime_timeout():
	coyotetime = false



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot_recoil" or anim_name == "shoot_toy":
		shotsfired = true
	if anim_name == "hurt":
		iframes = false


#reconnect if add back in 
#func _on_regenerationtimer_timeout():
#	heal(round(Game.playerhpmax * (0.02 + (Game.playerstats["Regeneration"] * 0.01))))
#	get_node("timers/regenerationtimer").wait_time = 5 - (4 * Game.playerstats["Regeneration"]/20)

func cancelreloadaudio():
	get_node("Gunarms/reload_clip_in").playing = false

func _on_berserktimer_timeout():
	Game.berserkshotcount = 0




func _on_doordetector_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.is_in_group("interact"):
		get_node("doordetector/Interact").visible = true


func _on_doordetector_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if (area == null) or  (area.is_in_group("interact") and get_node("doordetector/Interact").visible):
		get_node("doordetector/Interact").visible = false


func _on_iframes_timeout():
	iframes = false
	get_node("AnimatedSprite2D").material.set_shader_parameter("enable_sil",0)
	get_node("shoot_body_torso").material.set_shader_parameter("enable_sil",0)
	get_node("Gunarms/GunarmL/gun").material.set_shader_parameter("enable_sil",0)
	get_node("Gunarms/GunarmR/gun").material.set_shader_parameter("enable_sil",0)


func resetshaders():
	var parameters = ["enable_disintegrate", "enable_offset_shadow", "enable_blur", "enable_outline", "enable_sil"]
	var nodes = ["AnimatedSprite2D", "shoot_body_torso", "Gunarms/GunarmL/gun", "Gunarms/GunarmR/gun"]
	for i in nodes:
		for j in parameters:
			get_node(i).material.set_shader_parameter(j,0)
