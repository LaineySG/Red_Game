extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var wtf = preload("res://scene/mob/wtf.tscn")
var brokemessage = false
var textcheck = false
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
	get_node("death_screen").backtoship.connect(_on_death_screen_backtoship)
	get_node("UI").visible = true
	Utils.unpausegame()
	
		
	_on_player_update_ammo()
	_on_player_update_gun()
	_on_update_health()
	
	
	for i in get_node("item_room").get_children():
		if i.name.left(8) == "exitdoor":
			i.get_node("Area2D").locked = false
			#i.door_theme = "white_1"
	
	if !Variables.grimm_conversation_tracker.has("grimm_boss_1"):
		Variables.grimm_conversation_tracker.append("grimm_boss_1")
		get_node("mobs/grimm_boss").is_in_cutscene = true
		get_node("item_room/exitdoor").roomtype = "item"
		get_node("item_room/exitdoor").img_refresh()
		currentconversation = "grimm_boss_1"
		get_node("UI/Textboxanims").play("textboxappears")
		get_node("UI/Textbox").change_text("I was beginning to think you wouldn't make it. Let's get this over with.", "grimm")
		Variables.inputIsDisabled = true
	else:
		get_node("UI/Textboxanims").play("textboxappears")
		await get_tree().create_timer(0.05).timeout
		get_node("UI/Textboxanims").stop()
		get_node("mobs/grimm_boss").is_in_cutscene = false
	
	
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
	
	
	var hasmobs=false
	for i in get_node("mobs").get_children():
		if i.is_in_group("mob"):
			if !i.dead and !i.nopatience and !i.frozen and !i.dying:
				hasmobs = true
			else:
				pass
	if !hasmobs:
		for i in get_node("mobs").get_children():
			if i.is_in_group("mob"):
				i.setcombatinteractions(true)
	else:
		for i in get_node("mobs").get_children():
			if i.is_in_group("mob"):
				if i.nopatience or i.dead or i.frozen or i.dying:
					i.setcombatinteractions(false)
					
	if !hasmobs and !textcheck:
		textcheck = true
		if get_node("mobs/grimm_boss").nopatience:
			Variables.grimm_conversation_tracker.append("Grimm_Tired_1")
			get_node("mobs/grimm_boss").is_in_cutscene = true
			currentconversation = "Grimm_Tired_1"
			get_node("UI/Textbox").disabletext = false
			get_node("UI/Textboxanims").play("textboxappears")
			get_node("UI/Textbox").change_text("*The beast roars with laughter, the deadly glint in his eyes gone.*", "grimm")
			Variables.inputIsDisabled = true
		else:
			Variables.grimm_conversation_tracker.append("Grimm_Dead_1")
			currentconversation = "Grimm_Dead_1"
			get_node("UI/Textbox").disabletext = false
			get_node("UI/Textboxanims").play("textboxappears")
			get_node("UI/Textbox").change_text("*The body of the beast lies at your feet.*", "red")
			Variables.inputIsDisabled = true
			
			
		
	elif hasmobs:
		for i in get_node("item_room").get_children():
			if i.name.left(8) == "exitdoor":
				i.get_node("Area2D").locked = true

	if Input.is_action_just_pressed("ui_cancel") and !$UI/pause_modulation.visible:
		$UI/pause_modulation.visible = true
		Utils.pausegame()
		
	if Game.playerDied:
		Utils.pausegame()
		get_node("death_screen").playerdied()
	if Input.is_action_just_pressed("ui_I") and !get_node("UI/Inventory/Tutorial UI").visible:
		get_node("UI/Inventory/Tutorial UI").visible = true
		Game.inventorylock = true
		ammobar.value = Game.currentammo
	elif Input.is_action_just_pressed("ui_I") and get_node("UI/Inventory/Tutorial UI").visible:
		get_node("UI/Inventory/Tutorial UI").visible = false
		Game.inventorylock = false
		ammobar.value = Game.currentammo
		
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
		
		
		
		
	if get_node("Player").shielded:
		get_node("UI/player_health").material.set_shader_parameter("enable_outline",1)
	else:
		get_node("UI/player_health").material.set_shader_parameter("enable_outline",0)
		
		
func _on_update_health():
	hpbar.value = Game.playerhp

	


func _on_player_update_ammo():
	ammobar.value = Game.currentammo
	


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
	if currentconversation == "grimm_boss_1":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Wait, I have some things to ask you first.", "red")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Is this some sort of game to you? Do you not see what's at stake here?", "grimm")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Well... No actually, I don't. What is at stake?", "red")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*The beast flexes his back, apparently eager to get to fighting.*", "grimm")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("I suppose I can humor you. Your death won't be half as sweet if you don't know why you must die.", "grimm")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("The planet we came from was once a utopia...", "grimm")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("That is, until you came along and had to ruin everything.", "grimm")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("What did I do?", "red")
		elif conversation_step == 9:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Enough. Somewhere in that tiny brain of yours, you know what you did. I've no time for pleasantries. Let us end this.", "grimm")
		elif conversation_step == 10:
			conversation_step = 1
			get_node("mobs/grimm_boss").is_in_cutscene = false
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
	elif currentconversation == "Grimm_Tired_1":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("I will be merciful. You can leave this time. But cross me again and I won't be so kind.", "grimm")
		elif conversation_step ==2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Merciful? I won fair and square!","red")
		elif conversation_step == 3:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Do not try my patience, child.","grimm")
		elif conversation_step == 4:
			conversation_step +=1
			get_node("UI/Textbox").change_text("What about the bad thing? You said the stakes were high.", "red")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Bad thing? I know not what you speak of. I need to rest, leave me be.", "grimm")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*Suddenly, everything goes black as you're pulled through the void back to the spacecraft, and time reverses.*", "red")
		elif conversation_step == 7:
			conversation_step = 1
			get_node("mobs/grimm_boss").is_in_cutscene = true
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			get_node("TransitionScreen").transition()
			
	elif currentconversation == "Grimm_Dead_1":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*Grimm takes a shakey breath before speaking.* It was always going to come to this. One of us had to...", "grimm")
		elif conversation_step == 2:
			conversation_step +=1
			get_node("UI/Textbox").change_text("You mentioned the stakes earlier. Were you referring to the disaster?", "red")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Disaster? I did have plans, yes... But...","grimm")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*The beast's eyes gloss over with a final shudder.*", "grimm")
		elif conversation_step == 5:
			conversation_step +=1
			get_node("UI/Textbox").change_text("*Suddenly, everything goes black as you're pulled through the void back to the spacecraft, and time reverses.*", "red")
		elif conversation_step == 6:
			conversation_step = 1
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			get_node("TransitionScreen").transition()
			
			
func _on_transition_screen_transitioned():
	if Game.grimm_gun_kill_counter <= 1 or Game.grimm_toy_kill_counter <= 1:
		get_tree().change_scene_to_file("res://scene/levels/spaceship_hub.tscn")
		Game.runs +=1
		Game.playerDied = false
		Game._gamereset()
	else:
		doorchosen.changeroom()
	




func _on_death_screen_backtoship():
	Game.runs += 1
	Variables.grimm_conversation_tracker.append("Grimm_Lost_1")
	Game.playerDied = false
	Game._gamereset()
	get_tree().change_scene_to_file("res://scene/levels/spaceship_hub.tscn")


func _on_check_for_exit_which_door_opened(x):
	get_node("TransitionScreen").transition()
	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}
	doorchosen = x
