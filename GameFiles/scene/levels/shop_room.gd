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
	get_node("UI").visible = true
	get_node("items_for_sale/item1/Idea").cantafford.connect(_on_cant_afford)
	get_node("items_for_sale/item2/Idea").cantafford.connect(_on_cant_afford)
	get_node("items_for_sale/item3/Idea").cantafford.connect(_on_cant_afford)
	Utils.unpausegame()
	get_node("UI/Inventory").can_sell = true
	
		
	_on_player_update_ammo()
	_on_player_update_gun()
	_on_update_health()
	
	for i in get_node("item_room").get_children():
		if i.name.left(8) == "exitdoor":
			i.get_node("Area2D").locked = false
			i.door_theme = "white_1"
		
		
	var sleepchance = rng.randf()
	if sleepchance > 0.9:
		get_node("Sleeperagent").visible = true
		get_node("shop_owner").visible = false
		for i in get_node("items_for_sale").get_children():
			i.fivefingerdiscountset()
	
	if sleepchance <= 0.9:
		if !Variables.shop_conversation_tracker.has("shop_1"):
			Variables.shop_conversation_tracker.append("shop_1")
			currentconversation = "shop_1"
			get_node("UI/Textboxanims").play("textboxappears")
			get_node("UI/Textbox").change_text("Hello agent. It appears you're not wearing your uniform.", "agent")
			Variables.inputIsDisabled = true
		elif !Variables.shop_conversation_tracker.has("shop_2") and Game.runs > 2:
			Variables.shop_conversation_tracker.append("shop_2")
			currentconversation = "shop_2"
			get_node("UI/Textboxanims").play("textboxappears")
			get_node("UI/Textbox").change_text("Hello agent Red. Good to see you again. Did you hear the news?", "agent")
			Variables.inputIsDisabled = true
		else:
			get_node("UI/Textboxanims").play("textboxappears")
			await get_tree().create_timer(0.05).timeout
			get_node("UI/Textboxanims").stop()
	
	else:
		get_node("UI/Textboxanims").play("textboxappears")
		await get_tree().create_timer(0.05).timeout
		get_node("UI/Textboxanims").stop()
	
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
	if currentconversation == "shop_1":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Agent? I mean, yes! That's me, agent Red reporting for duty sir!", "red")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("I can't say I've seen you around here before. New hire?", "agent")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Yep, I just started!", "red")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Glad to have you here, cadet. We've got our hands full right now with all these aliens. When I get my hands on whoever released them...", "agent")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Yep I wish I knew too. No idea!", "red")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Well anyhow... Welcome to the commissary.", "agent")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Commissary?", "red")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Ah, you haven't been before. We offer items for CIA coins. They're our in-house currency.", "agent")
		elif conversation_step == 9:
			conversation_step += 1
			get_node("UI/Textbox").change_text("We also heal. Use the heart over there - the cost above shows the cost to heal fully. If you can't afford a full heal it will heal you for however many coins you have.", "agent")
		elif conversation_step == 10:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Thanks!", "red")
		elif conversation_step == 11:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Anything for a fellow agent.", "agent")
		elif conversation_step == 12:
			conversation_step = 1
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
	elif currentconversation == "shop_2":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("No, what news?", "red")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Ah, don't feel bad. Sometimes they only tell us higher ranks news like this.", "agent")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("What news?", "red")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*The agent leans in and hushes his voice.*", "agent")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("They say that the most dangerous subject escaped!", "agent")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Who is that?", "red")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Well... They didn't tell me that part. Just be careful out there, alright?", "agent")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("You know what? Here, free of charge. Don't tell your officer.", "agent")
			for i in get_node("items_for_sale").get_children():
				i.fivefingerdiscountset()
		elif conversation_step == 9:
			conversation_step = 1
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			
			
func _on_transition_screen_transitioned():
	get_node("UI/Inventory").can_sell = false
	doorchosen.changeroom()
		
	#get_tree().change_scene_to_file("res://scene/levels/spaceship_hub.tscn")
	pass


func _on_cant_afford():
	get_node("UI/gold").redflash()





func _on_check_for_exit_which_door_opened(x):
	get_node("TransitionScreen").transition()
	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}
	doorchosen = x


func _on_idea_hideitem(_item):
		get_node("UI/Inventory/CanvasLayer").visible = false

func _on_idea_viewitem(_item, itemstats):
		get_node("UI/Inventory/CanvasLayer").visible = true
		get_node("UI/Inventory/CanvasLayer/TextureRect").global_position = Vector2(50,125)
		get_node("UI/Inventory/CanvasLayer/TextureRect/MarginContainer/RichTextLabel2").item_info_parser(itemstats,true) #is shop = true


