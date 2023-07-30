extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var wtf = preload("res://scene/mob/wtf.tscn")
var brokemessage = false
var doorchosen
var visited = false
var introstep = 0
var rng = RandomNumberGenerator.new()
var helpcounter = 0
var currentconversation = ""
var conversation_step = 1
var tutorial_finished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.newRoom()
	player.update_ammo.connect(_on_player_update_ammo)
	player.update_gun.connect(_on_player_update_gun)
	player.update_health.connect(_on_update_health)
	#get_node("UI/Textbox").changetext.connect(_on_textbox_changetext)
	get_node("UI").visible = true
	Utils.unpausegame()
	
		
	_on_player_update_ammo()
	_on_player_update_gun()
	_on_update_health()
	
	
	for i in get_node("item_room").get_children():
		if i.name.left(8) == "exitdoor":
			i.get_node("Area2D").locked = false
			i.door_theme = "white_1"
	
	if !Variables.grimm_conversation_tracker.has("grimm_1"):
		Variables.grimm_conversation_tracker.append("grimm_1")
		get_node("item_room/exitdoor").roomtype = "item"
		get_node("item_room/exitdoor").img_refresh()
		currentconversation = "grimm_1"
		get_node("UI/Textboxanims").play("textboxappears")
		get_node("UI/Textbox").change_text("I finally caught your scent... It didn't take long.", "grimm")
		Variables.inputIsDisabled = true
	else:
		get_node("UI/Textboxanims").play("textboxappears")
		await get_tree().create_timer(0.05).timeout
		get_node("UI/Textboxanims").stop()
		Variables.inputIsDisabled = false
		get_node("Grimm").visible = false
	
	
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
	if get_node("item_room/exitdoor").roomtype == "meeting":
		get_node("item_room/exitdoor").roomtype = "item"
		get_node("item_room/exitdoor").img_refresh()
		
		
	if Input.is_action_just_pressed("ui_cancel") and !$UI/pause_modulation.visible:
		$UI/pause_modulation.visible = true
		Utils.pausegame()
		
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
	if currentconversation == "grimm_1":
		if conversation_step == 1:
			conversation_step += 1
			if Game.toy_kill_counter >= Game.gun_kill_counter:
				get_node("UI/Textbox").change_text("Confetti and... Joy... *The beast sneers in disgust.*", "grimm")
			else:
				get_node("UI/Textbox").change_text("A trail of blood and carnage... *The beast seems to savor the words.*", "grimm")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Who are you?", "red")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Y- Seriously? You don't remember???", "grimm")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*The beasts tone shifts to incredulity, as if offended that you don't know him.*", "grimm")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Sorry, but no. They seem to have done something to my memory here.", "red")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*The beasts growls impatiently.*", "grimm")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("This changes nothing. You and I have a score to settle.", "grimm")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("But who are you?", "red")
		elif conversation_step == 9:
			conversation_step += 1
			get_node("UI/Textbox").change_text("They call me Grimm. YOU called me Grimm... But I suppose those times are behind us now.", "grimm")
		elif conversation_step == 10:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Mark my words Red... Memory or not, I will have my revenge. But I will be fair. You don't look terribly prepared right now.", "grimm")
		elif conversation_step == 11:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Come find me outside the director's office. Then we can finish this.", "grimm")
		elif conversation_step == 12:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Where is the direc-", "red")
		elif conversation_step == 13:
			conversation_step += 1
			get_node("TransitionScreen").transition()
		elif conversation_step == 14:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Aaand he's gone. What a strange beast.", "red")
		elif conversation_step == 15:
			conversation_step = 1
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			
			
func _on_transition_screen_transitioned():
	if conversation_step >= 12:
		get_node("Grimm").visible = false
	else:
		doorchosen.changeroom()
	




func _on_check_for_exit_which_door_opened(x):
	get_node("TransitionScreen").transition()
	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}
	doorchosen = x
