extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var wtf = preload("res://scene/mob/wtf.tscn")
var brokemessage = false
var introstep = 0
var hasmobs=false
var rng = RandomNumberGenerator.new()
var timetrialchance = 0
var death_screen_playing = false
var helpcounter = 0
var hpregenerated = false
var conversation_step = 1
var tutorial_finished = false
var doorchosen

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.newRoom()
	get_node("mobs/Mobgenerator").instantiate(1,1) # level, floor
	player.update_ammo.connect(_on_player_update_ammo)
	player.update_gun.connect(_on_player_update_gun)
	player.update_health.connect(_on_update_health)
	get_node("fight_room/check_for_exit").which_door_opened.connect(_on_check_for_exit_which_door_opened)
	get_node("death_screen").backtoship.connect(_on_death_screen_backtoship)
	_on_player_update_ammo()
	_on_player_update_gun()
	Musicplayer.playsong("combat")
	_on_update_health()
	
	##check for time trial##
	timetrialchance = rng.randf()
	if timetrialchance >= (0.95 - (0.15 * Game.player_talents_current["Boon of Fortune"])):
		get_node("UI/time_trial_timer").combat = true
		get_node("UI/time_trial_timer").timetrial = true
		var randtimervar = rng.randi_range(5,12)
		var goldmod = 25 - randtimervar
		get_node("UI/time_trial_timer").goldmod = goldmod
		get_node("UI/time_trial_timer").maxtimer = (randtimervar * get_node("mobs/Mobgenerator").enemycount)
		get_node("UI/time_trial_timer").init()
	else:
		get_node("UI/time_trial_timer").combat = false
		get_node("UI/time_trial_timer").timetrial = false
		get_node("UI/time_trial_timer").init()
	
	get_node("UI/Textboxanims").play("textboxappears")
	await get_tree().create_timer(0.05).timeout
	get_node("UI/Textboxanims").stop()
		
	Utils.unpausegame()
	get_node("UI").visible = true
	
	
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = false
		get_node("UI/sidearm/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
		get_node("UI/sidearm/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = true
		get_node("UI/sidearm/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = true
		get_node("UI/sidearm/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	hasmobs=false
	for i in get_node("mobs").get_children():
		if i.is_in_group("mob"):
			if !i.dead and !i.nopatience and !i.frozen and !i.dying:
				hasmobs = true
			else:
				pass
	if !hasmobs: # room clear
		for j in get_node("fight_room").get_children():
			if j.name.left(4) == "exit":
				j.get_node("Area2D").add_to_group("interact")
		for i in get_node("mobs").get_children():
			if i.is_in_group("mob"):
				i.setcombatinteractions(true)
		if !hpregenerated:
			hpregenerated = true
			player.heal(ceil((Game.playerstats["Regeneration"] / 4.0 * Game.playerhpmax * 0.04))) # heal 2% of player health * 1-5 depending on regeneration stat
			
			
	else: # if enemies 
		for j in get_node("fight_room").get_children():
			if j.name.left(4) == "exit":
				j.get_node("Area2D").remove_from_group("interact")
		for i in get_node("mobs").get_children():
			if i.is_in_group("mob"):
				if i.nopatience or i.dead or i.frozen or i.dying:
					i.setcombatinteractions(false)
					
	if !hasmobs:
		for i in get_node("fight_room").get_children():
			if i.name.left(8) == "exitdoor":
				i.get_node("Area2D").locked = false
		Musicplayer.playsong("relaxed")
		
		if timetrialchance > 0.95:
			get_node("UI/time_trial_timer").combat = false
			timetrialchance = 0
		
		
	elif hasmobs:
		for i in get_node("fight_room").get_children():
			if i.name.left(8) == "exitdoor":
				i.get_node("Area2D").locked = true
		if Musicplayer.getcurrentsong() == "relaxed": # if you shoot a nopatience enemy
			Musicplayer.playsong("combat")
		
		
	if Input.is_action_just_pressed("ui_cancel") and !$UI/pause_modulation.visible:
		$UI/pause_modulation.visible = true
		Utils.pausegame()
	if Input.is_action_just_pressed("ui_cancel") and get_node("UI/Inventory/Tutorial UI").visible:
		get_node("UI/Inventory/Tutorial UI").visible = false
		Game.inventorylock = false
	
	if Game.playerDied and !death_screen_playing:
		get_node("death_screen").playerdied()
		death_screen_playing = true
		
	if Input.is_action_just_pressed("ui_I") and !get_node("UI/Inventory/Tutorial UI").visible:
		get_node("UI/Inventory/Tutorial UI").visible = true
		Game.inventorylock = true
		if Game.weapon_equipped == "gun":
			ammobar.value = Game.currentammo
		elif Game.weapon_equipped == "toygun":
			ammobar.value = Game.currenttoyammo
	elif Input.is_action_just_pressed("ui_I") and get_node("UI/Inventory/Tutorial UI").visible:
		get_node("UI/Inventory/Tutorial UI").visible = false
		Game.inventorylock = false
		if Game.weapon_equipped == "gun":
			ammobar.value = Game.currentammo
		elif Game.weapon_equipped == "toygun":
			ammobar.value = Game.currenttoyammo
		
		#remove later - testing purposes
	if Input.is_action_just_pressed("ui_home") and get_node("testbox").visible == false:
		get_node("testbox").visible = true
		Game.inventorylock = true
	elif Input.is_action_just_pressed("ui_home") and get_node("testbox").visible == true:
		get_node("testbox").visible = false
		Game.inventorylock = false
		#remove later - testing purposes 
	
	var mouse_offset = (get_viewport().get_mouse_position() - Vector2(get_viewport().size / 2))
	$Player/Camera2D.position = lerp(Vector2(), mouse_offset.normalized() * 50, mouse_offset.length() / 1000)
	
	var cursor = 0
	
	if Input.is_action_just_pressed("ui_end"):
		#print(Game.current_abilities)
		pass
	
	if Game.current_abilities.has("Dash"):
		get_node("UI/cooldowns/dashCD").visible = true
		get_node("UI/cooldowns/dashCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Dash"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/dashCD/Label").text = output
	else:
		get_node("UI/cooldowns/dashCD").visible = false
		
	if Game.current_abilities.has("Teleport"):
		get_node("UI/cooldowns/teleCD").visible = true
		get_node("UI/cooldowns/teleCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Teleport"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/teleCD/Label").text = output
	else:
		get_node("UI/cooldowns/teleCD").visible = false
		
	if Game.current_abilities.has("Camoflague"):
		get_node("UI/cooldowns/camoCD").visible = true
		get_node("UI/cooldowns/camoCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Camoflague"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/camoCD/Label").text = output
	else:
		get_node("UI/cooldowns/camoCD").visible = false
		
	if Game.current_abilities.has("Sprint"):
		get_node("UI/cooldowns/sprintCD").visible = true
		get_node("UI/cooldowns/sprintCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Sprint"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/sprintCD/Label").text = output
	else:
		get_node("UI/cooldowns/sprintCD").visible = false
		
	if Game.current_abilities.has("Shield"):
		get_node("UI/cooldowns/shieldCD").visible = true
		get_node("UI/cooldowns/shieldCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Shield"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/shieldCD/Label").text = output
	else:
		get_node("UI/cooldowns/shieldCD").visible = false
		
		
	if Game.current_abilities.has("Balloon"):
		get_node("UI/cooldowns/balloonCD").visible = true
		get_node("UI/cooldowns/balloonCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Balloon"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/balloonCD/Label").text = output
	else:
		get_node("UI/cooldowns/balloonCD").visible = false
		
	if Game.current_abilities.has("Summon(Green Aliens)"):
		get_node("UI/cooldowns/greenalienCD").visible = true
		get_node("UI/cooldowns/greenalienCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Summon(Green Aliens)"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/greenalienCD/Label").text = output
	else:
		get_node("UI/cooldowns/greenalienCD").visible = false
		
		
	if Game.current_abilities.has("Summon(CIA Drone)"):
		get_node("UI/cooldowns/droneCD").visible = true
		get_node("UI/cooldowns/droneCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Summon(CIA Drone)"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/droneCD/Label").text = output
	else:
		get_node("UI/cooldowns/droneCD").visible = false
		
	if Game.current_abilities.has("Land Mine"):
		get_node("UI/cooldowns/mineCD").visible = true
		get_node("UI/cooldowns/mineCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Land Mine"]
		if output == "S":
			output = "->"
		get_node("UI/cooldowns/mineCD/Label").text = output
	else:
		get_node("UI/cooldowns/mineCD").visible = false
		
		
		
				
	if !get_node("Player/timers/dottimer").is_stopped():
		get_node("UI/DoTtimers/DoTTimer").visible = true
		var percent = get_node("Player/timers/dottimer").time_left / get_node("Player/timers/dottimer").wait_time
		get_node("UI/DoTtimers/DoTTimer").value = (percent * 100)
		if player.currentDoTs > 1:
			get_node("UI/DoTtimers/DoTTimer/Label").text = str(player.currentDoTs)
	else:
		get_node("UI/DoTtimers/DoTTimer").visible = false
	
		
	if !get_node("Player/timers/dash_CD").is_stopped():
		var percent = get_node("Player/timers/dash_CD").time_left / get_node("Player/timers/dash_CD").wait_time
		get_node("UI/cooldowns/dashCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/dashCD").value = 100
		
	if !get_node("Player/timers/tele_CD").is_stopped():
		var percent = get_node("Player/timers/tele_CD").time_left / get_node("Player/timers/tele_CD").wait_time
		get_node("UI/cooldowns/teleCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/teleCD").value = 100
		
	if !get_node("Player/timers/camo_CD").is_stopped():
		var percent = get_node("Player/timers/camo_CD").time_left / get_node("Player/timers/camo_CD").wait_time
		get_node("UI/cooldowns/camoCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/camoCD").value = 100
		
	if !get_node("Player/timers/sprint_CD").is_stopped():
		var percent = get_node("Player/timers/sprint_CD").time_left / get_node("Player/timers/sprint_CD").wait_time
		get_node("UI/cooldowns/sprintCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/sprintCD").value = 100
		
	if !get_node("Player/timers/greenalien_CD").is_stopped():
		var percent = get_node("Player/timers/greenalien_CD").time_left / get_node("Player/timers/greenalien_CD").wait_time
		get_node("UI/cooldowns/greenalienCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/greenalienCD").value = 100
		
	if !get_node("Player/timers/shield_CD").is_stopped():
		var percent = get_node("Player/timers/shield_CD").time_left / get_node("Player/timers/shield_CD").wait_time
		get_node("UI/cooldowns/shieldCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/shieldCD").value = 100
		
	if !get_node("Player/timers/mine_CD").is_stopped():
		var percent = get_node("Player/timers/mine_CD").time_left / get_node("Player/timers/mine_CD").wait_time
		get_node("UI/cooldowns/mineCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/mineCD").value = 100
		
	if !get_node("Player/timers/balloon_CD").is_stopped():
		var percent = get_node("Player/timers/balloon_CD").time_left / get_node("Player/timers/balloon_CD").wait_time
		get_node("UI/cooldowns/balloonCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/balloonCD").value = 100
		
	if !get_node("Player/timers/drone_CD").is_stopped():
		var percent = get_node("Player/timers/drone_CD").time_left / get_node("Player/timers/drone_CD").wait_time
		get_node("UI/cooldowns/droneCD").value = 100 - (percent * 100)
	else:
		get_node("UI/cooldowns/droneCD").value = 100
		
		
		
		
	if get_node("Player").shielded:
		get_node("UI/player_health").material.set_shader_parameter("enable_outline",1)
	else:
		get_node("UI/player_health").material.set_shader_parameter("enable_outline",0)
		
		
func _on_update_health():
	hpbar.value = Game.playerhp


	


func _on_player_update_ammo():
	if Game.weapon_equipped == "gun":
		ammobar.value = Game.currentammo
	elif Game.weapon_equipped == "toygun":
		ammobar.value = Game.currenttoyammo
	


func _on_player_update_gun():
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = false
		get_node("UI/sidearm/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
		get_node("UI/sidearm/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = true
		get_node("UI/sidearm/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = true
		get_node("UI/sidearm/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false


			


func _on_textbox_changetext():
	pass


func _on_transition_screen_transitioned():
	for children in get_node("mobs").get_children():
		if children.is_in_group("coins"):
			children.add_on_exit()
	doorchosen.changeroom()
		
	#get_tree().change_scene_to_file("res://scene/levels/spaceship_hub.tscn")



func _on_death_screen_backtoship():
	get_tree().change_scene_to_file("res://scene/levels/spaceship_hub.tscn")
	Game.runs +=1
	Game.playerDied = false
	Game._gamereset()




func _on_check_for_exit_which_door_opened(x):
	get_node("TransitionScreen").transition()
	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}
	doorchosen = x
