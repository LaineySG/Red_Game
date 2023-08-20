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
	Musicplayer.playsong("relaxed")
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
			if self.name != "pub_room":
				i.door_theme = "white_1"
			else:
				i.door_theme = "cyberbar"
	
	if !Variables.bob_conversation_tracker.has("bob_1"):
		Variables.bob_conversation_tracker.append("bob_1")
		currentconversation = "bob_1"
		get_node("UI/Textboxanims").play("textboxappears")
		get_node("UI/Textbox").change_text("Howdy. The name's Bob. James Bob. But you can call be Bob.", "bob")
		Variables.inputIsDisabled = true
	elif !Variables.bob_conversation_tracker.has("bob_2"):
		Variables.bob_conversation_tracker.append("bob_2")
		currentconversation = "bob_2"
		get_node("UI/Textboxanims").play("textboxappears")
		_on_textbox_changetext()
		Variables.inputIsDisabled = true
	elif !Variables.bob_conversation_tracker.has("bob_3"):
		Variables.bob_conversation_tracker.append("bob_3")
		currentconversation = "bob_3"
		get_node("UI/Textboxanims").play("textboxappears")
		_on_textbox_changetext()
		Variables.inputIsDisabled = true
	else:
		get_node("UI/Textboxanims").play("textboxappears")
		await get_tree().create_timer(0.05).timeout
		get_node("UI/Textboxanims").stop()
		Variables.inputIsDisabled = false
		get_node("Bob").visible = false
	
	
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
		
		
		
		
	if Input.is_action_just_pressed("ui_cancel") and (get_node("UI/Inventory/Tutorial UI").visible or get_node("UI/Inventory/Talents").visible or get_node("UI/Inventory/Stats").visible):
		get_node("UI/Inventory/Tutorial UI").visible = false
		get_node("UI/Inventory/Stats").visible = false
		get_node("UI/Inventory/Talents").visible = false
		Game.inventorylock = false
		
	if Input.is_action_just_pressed("ui_I") and !get_node("UI/Inventory/Tutorial UI").visible and !get_node("UI/Inventory/Stats").visible and !get_node("UI/Inventory/Talents").visible:
		get_node("UI/Inventory/Tutorial UI").visible = true
		Game.inventorylock = true
		if Game.weapon_equipped == "gun":
			ammobar.value = Game.currentammo
		elif Game.weapon_equipped == "toygun":
			ammobar.value = Game.currenttoyammo
	elif Input.is_action_just_pressed("ui_I") and (get_node("UI/Inventory/Tutorial UI").visible or get_node("UI/Inventory/Talents").visible or get_node("UI/Inventory/Stats").visible):
		get_node("UI/Inventory/Tutorial UI").visible = false
		get_node("UI/Inventory/Stats").visible = false
		get_node("UI/Inventory/Talents").visible = false
		Game.inventorylock = false
		if Game.weapon_equipped == "gun":
			ammobar.value = Game.currentammo
		elif Game.weapon_equipped == "toygun":
			ammobar.value = Game.currenttoyammo
		
	
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
	if currentconversation == "bob_1":
		if conversation_step == 1:
			conversation_step += 1
			if Game.toy_kill_counter < Game.gun_kill_counter:
				get_node("UI/Textbox").change_text("Not often newfolk swing by 'round here. Never mind a cowgirl as battle-hardened as yourself... Welcome to the saloon.", "bob")
			else:
				get_node("UI/Textbox").change_text("Not often newfolk swing by 'round here. Did I miss bring your kids to work day? You shouldn' be here anyway, a saloon ain't no place for kids.", "bob")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("What's your deal?", "red")
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Deal? *The man takes a puff of his cigarette while staring at the wall.* Guess I'm a cowboy on the run.", "bob")
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("On the run from what?", "red")
		elif conversation_step == 5:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Never you mind, lil' miss. What's your name, anyhow?", "bob")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("The name's Red.", "red")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Funny, you don't strike me as a Red. More of a Bessica. Or a Snooch, like my old wolfhound.", "bob")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("You think I look like my name is Snooch?", "red")
		elif conversation_step == 9:
			conversation_step += 1
			get_node("UI/Textbox").change_text("A cowboy is many things, but he ain't no liar, Snooch.", "bob")
		elif conversation_step == 10:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Don't call me Snooch.", "red")
		elif conversation_step == 11:
			conversation_step += 1
			get_node("UI/Textbox").change_text("A cowboy ain't got no time to argue. Be on your way, lil' lady.", "bob")
		elif conversation_step == 12:
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
	if currentconversation == "bob_2":
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Snooch! Fancy seeing you 'round here again.", "bob")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Are you really a cowboy?", "red")	
		elif conversation_step == 3:
			conversation_step += 1
			get_node("UI/Textbox").change_text("*Bob coughs on his cigarette, apparently scoffing at your question.* Listen to you, asking if I'm \"really a cowboy\" ... If I ain't a cowboy then you ain't a snooch! *He continues to howl with laughter.*" , "bob")	
		elif conversation_step == 4:
			conversation_step += 1
			get_node("UI/Textbox").change_text("But I'm not... Never mind." , "red")	
		elif conversation_step == 5:
			conversation_step += 1 
			get_node("UI/Textbox").change_text("I'm surprised you never heard of me before. I'm a world famous mechanical horse rider, and the best shot in the west." , "bob")	
		elif conversation_step == 6:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Best in the west, huh? According to who?" , "red")	
		elif conversation_step == 7:
			conversation_step +=1
			get_node("UI/Textbox").change_text("According to the western cowboy olympics, 'course. Anywho, 'nuff about me. What're you doing here?" , "bob")	
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("I'm trying to stop a bad thing from happening." , "red")			
		elif conversation_step == 9:
			conversation_step +=1 
			get_node("UI/Textbox").change_text("Bad thing, huh? I've had to deal with a bad thing or two in my time. But you know, dealin' with bad stuff is kinda like bustin' broncs: you're gonna get thrown a lot. The secret's to keep gettin' back on." , "bob")	
		elif conversation_step == 10:
			conversation_step +=1 
			get_node("UI/Textbox").change_text("That's... Actually good advice." , "red")	
		elif conversation_step == 11:
			conversation_step += 1
			get_node("UI/Textbox").change_text("'Course it's good advice. I've had to give advice once or twice 'fore. But ya know, givin' advice is like bustin' broncs: You're gonna get thrown a lot, but the secret? Keep gettin' back on." , "bob")	
		elif conversation_step == 12:
			conversation_step += 1 
			get_node("UI/Textbox").change_text("That's the same advice you just gave me." , "red")
		elif conversation_step == 13:
			conversation_step += 1
			get_node("UI/Textbox").change_text("All my advice is worth repeatin'. Anyway I got a drink to finish, it was good catchin' up with you though Snooch." , "bob")		
		elif conversation_step == 13:
			conversation_step += 1
			get_node("UI/Textbox").change_text("...", "red")
		elif conversation_step == 14:
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
	if currentconversation == "bob_3":	
		if conversation_step == 1:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Howdy...", "bob")
		elif conversation_step == 2:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Are you alright? You don't seem your usual up-beat self.", "red")	
		elif conversation_step == 3:
			conversation_step += 1 
			get_node("UI/Textbox").change_text("Ain't nothing gets past you, huh Snooch? Just like my boy... You're a lot like him you know.", "bob")
		elif conversation_step == 4:
			conversation_step +=1 
			get_node("UI/Textbox").change_text("Your boy Snooch? Your dog? How am I similar to your dog?", "red")
		elif conversation_step == 5:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Don't miss nothing. Always talk to me when noone else will. Positive can-do attitude. Loyal to his last breath... You even have the same name!", "bob")
		elif conversation_step == 6:
			conversation_step += 1
			get_node("UI/Textbox").change_text("When you put it like that... I guess you can call me Snooch if you want.", "red")
		elif conversation_step == 7:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Don't need your permission, kid.", "bob")
		elif conversation_step == 8:
			conversation_step += 1
			get_node("UI/Textbox").change_text("You didn't really answer my question though, why are you so glum?", "red")
		elif conversation_step == 9:
			conversation_step += 1
			get_node("UI/Textbox").change_text("Just 'been feelin' weird lately. Like I'm... Stuck in a loop or something, ya know?.", "bob")
		elif conversation_step == 10:
			conversation_step += 1
			get_node("UI/Textbox").change_text("I definitely know the feeling. Why do you hang out here all day, anyway?","red")
		elif conversation_step == 11:
			conversation_step += 1
			var blood = ""
			if Game.toy_kill_counter < Game.gun_kill_counter:
				blood = "blood"
			else:
				blood = "confetti"
			var textout = "Ain't got nowhere else to be, I s'pose. " + "Plus there's too much " + str(blood) + " out there, I keep slippin' on the floors."
			get_node("UI/Textbox").change_text(textout,"bob")
		elif conversation_step == 12:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Sorry... Hey, I've got an idea. Wanna hang out in my spaceship?","red")
		elif conversation_step == 13:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Woah, you've got a spaceship? So you must be an alien then. Well, Ain't got nowhere better to be. I'll take you up on your offer. I'll head over after I finish this drink.","bob")
		elif conversation_step == 14:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Cool, I'll see you there.","red")
		elif conversation_step == 15:
			conversation_step +=1
			get_node("UI/Textbox").change_text("Thanks Snooch, this means a lot to me. Most folk 'round here don't bother to stop and talk to a cowboy.", "bob")
		elif conversation_step == 16:
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			
func _on_transition_screen_transitioned():
		doorchosen.changeroom()
	




func _on_check_for_exit_which_door_opened(x):
	get_node("TransitionScreen").transition()
	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}
	doorchosen = x
