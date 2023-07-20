extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var wtf = preload("res://scene/mob/wtf.tscn")
var brokemessage = false
var helpcounter = 0
var current_blue_convo = ""
var current_prof_convo = ""
var morality_tracker
var currentconversation
var conversation_step = 1
@onready var textbox = get_node("UI/Textbox")
var player_in_portal = false

func conversationselector():
	if Variables.grimm_conversation_tracker.has("Grimm_Dead_1") and !Variables.prof_conversation_tracker.has("prof_3"):
		current_prof_convo = "prof_3" # killed grimm
	elif Variables.grimm_conversation_tracker.has("Grimm_Tired_1") and !Variables.prof_conversation_tracker.has("prof_4"):
		current_prof_convo = "prof_4" # toygunned grimm
	elif Variables.grimm_conversation_tracker.has("Grimm_Lost_1") and !Variables.prof_conversation_tracker.has("prof_5"):
		current_prof_convo = "prof_5" # lost to grimm
	elif Game.runs >= 2 and !Variables.prof_conversation_tracker.has("prof_1"):
		current_prof_convo = "prof_1"
	elif Game.runs >= 2 and !Variables.prof_conversation_tracker.has("prof_2") and Variables.grimm_conversation_tracker.has("grimm_1"):
		current_prof_convo = "prof_2"
		
	if Variables.grimm_conversation_tracker.has("Grimm_Dead_1") and !Variables.blue_conversation_tracker.has("blue_3"):
		current_blue_convo = "blue_3" # killed grimm
	elif Variables.grimm_conversation_tracker.has("Grimm_Tired_1") and !Variables.blue_conversation_tracker.has("blue_4"):
		current_blue_convo = "blue_4" # toygunned grimm
	elif Variables.grimm_conversation_tracker.has("Grimm_Lost_1") and !Variables.blue_conversation_tracker.has("blue_5"):
		current_blue_convo = "blue_5" # lost to grimm
	elif Game.runs >= 2 and !Variables.blue_conversation_tracker.has("blue_1"):
		current_blue_convo = "blue_1"
	elif Game.runs >= 2 and !Variables.blue_conversation_tracker.has("blue_2"):
		current_blue_convo = "blue_2"

	
	if current_prof_convo != "":	
		get_node("prof").has_conversation = true
	else:
		get_node("prof").has_conversation = false
		
	if current_blue_convo != "":
		get_node("Blue").has_conversation = true
	else:
		get_node("Blue").has_conversation = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerhp = Game.playerhpmax
	Game.newRoom()
	conversation_step = 1
	player.update_ammo.connect(_on_player_update_ammo)
	player.update_gun.connect(_on_player_update_gun)
	player.update_health.connect(_on_update_health)
	get_node("UI/Textbox").changetext.connect(_on_textbox_changetext)
	
	if Game.toy_kill_counter > Game.gun_kill_counter or (Game.toy_kill_counter == 0 and Game.gun_kill_counter == 0):
		morality_tracker = "good"
	else:
		morality_tracker = "evil"
	
	Utils.unpausegame()
	
	if Game.runs == 0:
		get_node("UI/Textboxanims").play("textboxappears")
		get_node("UI/Textbox").change_text("[i]whisper whisper[/i]", "blue")
		Variables.inputIsDisabled = true
		get_node("Player/AnimatedSprite2D").flip_h = true
	elif Game.runs == 1 and !Variables.grimm_conversation_tracker.has("Grimm_Tired_1") and !Variables.grimm_conversation_tracker.has("Grimm_Dead_1"):
		Variables.inputIsDisabled = true
		get_node("Player/AnimatedSprite2D").flip_h = true
		get_node("UI/Textboxanims").play("textboxappears")
		get_node("UI/Textbox").change_text("No, no, we definitely did it right. It just takes a momen- There she is!", "prof")
	elif Game.runs >= 2 or (Variables.grimm_conversation_tracker.has("Grimm_Tired_1") or Variables.grimm_conversation_tracker.has("Grimm_Dead_1")):
		conversationselector()
		get_node("UI/Textboxanims").play("textboxappears")
		await get_tree().create_timer(0.05).timeout
		get_node("UI/Textboxanims").stop()
		get_node("Blue").position.x = 350
	
	#get_tree().reload_current_scene()
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
	if Input.is_action_just_pressed("ui_E") and player_in_portal:
		get_node("TransitionScreen").transition()
	

	if Input.is_action_just_pressed("ui_cancel") and !$UI/pause_modulation.visible:
		$UI/pause_modulation.visible = true
		Utils.pausegame()
		
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
		
	if Game.current_abilities.has("Summon (Green Aliens)"):
		get_node("UI/cooldowns/greenalienCD").visible = true
		get_node("UI/cooldowns/greenalienCD").position.x = (-36 * cursor)
		cursor += 1
		var output = Game.current_abilities["Summon (Green Aliens)"]
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
		
		if currentconversation == "prof_1":
			if conversation_step == 1:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("From what I've seen, you're certainly making a positive impact. But er... You know those aliens are trying to kill you, yes?","prof")
				else:
					textbox.change_text("But you've made quite a name for yourself already. The evil aliens fear you! Blue definitely made the right choice with you!","prof")
			elif conversation_step == 2:
				conversation_step = 1
				currentconversation = ""
				Variables.inputIsDisabled = false
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
				
		elif currentconversation == "blue_1":
			if conversation_step == 1:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("Wait that's not how I wanted to say this. I'd just like to be friends, that's all. ","blue")
				else:
					textbox.change_text("Wait a minute, what's that red stuff all over your clothes..?","blue")
			elif conversation_step == 2:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("It's ok, dying just makes me a little agitated.","red")
				else:
					textbox.change_text("...","red")
			elif conversation_step == 3:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("I wish I could help somehow. I know, I'll be on the lookout for treasure for you!","blue")
				else:
					textbox.change_text("...","blue")
			elif conversation_step == 4:
				conversation_step = 1
				Variables.inputIsDisabled = false
				currentconversation = ""
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
		
		elif currentconversation == "prof_2":
			if conversation_step == 1:
				conversation_step += 1
				textbox.change_text("Professor, I met a hairy man named... Grimm? He says he knew me from my past. Have you heard of him?","red")
			elif conversation_step == 2:
				conversation_step += 1
				textbox.change_text("I'm sorry, I can't say I have. You will run into him again, of course. Due to the time anomalies, he should remember your previous encounters. Perhaps he will reveal something useful to you.","prof")
			elif conversation_step == 3:
				conversation_step = 1
				currentconversation = ""
				Variables.inputIsDisabled = false
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
				
		elif currentconversation == "blue_2":
			if conversation_step == 1:
				conversation_step += 1
				textbox.change_text("I'm so glad you came back here to talk to me!","blue")
			elif conversation_step == 2:
				conversation_step += 1
				textbox.change_text("I mean, I'm not glad that you died of course. But I have something important to tell you! ","blue")
			elif conversation_step == 3:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("It's about those ghosts you keep running into!","blue")
				else:
					textbox.change_text("It's about those ghosts you keep... Killing? Can you kill a ghost?","blue")
			elif conversation_step == 4:
				conversation_step += 1
				if morality_tracker == "good":
					textbox.change_text("How do you know I am seeing ghosts?","red")
				else:
					textbox.change_text("I'm certainly trying... Wait a second, how do you know I am seeing ghosts?","red")
			elif conversation_step == 5:
				conversation_step += 1
				textbox.change_text("The professor hacked into the agency's security cameras! We've been watching you and-","blue")
			elif conversation_step == 6:
				conversation_step += 1
				textbox.change_text("You've been watching me die each time?","red")
			elif conversation_step == 7:
				conversation_step += 1
				textbox.change_text("Well, yeah. How else do you think we know when to reverse time? Anyway so I was playing ball in the electrical room earlier","blue")
			elif conversation_step == 8 :
				conversation_step += 1
				textbox.change_text("Because the professor gets huffy sometimes and says she \"needs a break from me\". Can you believe it? Anyway so I was playing ball in the electrical room earlier","blue")
			elif conversation_step == 9:	
				conversation_step += 1
				textbox.change_text("And out of nowhere a ghost came through the wall! At first I was really scared but then I realized something - I was holding a weapon!","blue")
			elif conversation_step == 10:
				conversation_step += 1
				textbox.change_text("So I threw the ball at it at the same time it threw a scary ghostly cloud at me, and the scary cloud went \"poof!\" and vanished!", "blue")
			elif conversation_step == 11:
				conversation_step += 1
				textbox.change_text("So I ran back here. I think the moral of the story is, throw balls at the ghost clouds. Or something like that, anyway...", "blue")
			elif conversation_step == 12:
				conversation_step = 1
				Variables.inputIsDisabled = false
				currentconversation = ""
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
		elif currentconversation == "blue_3" or currentconversation == "blue_4":
			if conversation_step == 1:
				conversation_step += 1
				textbox.change_text("Well, I don't want to be the bearer of bad news. A bad news bear, as they say. You should talk to the prof!","blue")
			elif conversation_step == 2:
				conversation_step += 1
				if Variables.prof_conversation_tracker.has("prof_3") or Variables.prof_conversation_tracker.has("prof_4"):
					textbox.change_text("Yeah, I talked to her already... Is there any good news?", "red")
				else:
					textbox.change_text("Is there any good news? Or only bad?","red")
			elif conversation_step == 3:
				conversation_step += 1
				textbox.change_text("Good news? You didn't die!","blue")
			elif conversation_step == 4:
				conversation_step = 1
				Variables.inputIsDisabled = false
				currentconversation = ""
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
				
				
		elif currentconversation == "prof_3" or currentconversation == "prof_4":
			if conversation_step == 1:
				conversation_step += 1
				textbox.change_text("Unfortunately, I have some bad news.","prof")
			elif conversation_step == 2:
				conversation_step += 1
				if Variables.blue_conversation_tracker.has("blue_3") or Variables.blue_conversation_tracker.has("blue_4"):
					textbox.change_text("Yeah, I talked to Blue. She mentioned something bad happened?", "red")
				else:
					textbox.change_text("Awful news, really.","prof")
			elif conversation_step == 3:
				conversation_step += 1
				textbox.change_text("To put it simply, the disaster happened. that's why we had to reverse time.","prof")
			elif conversation_step == 4:
				conversation_step += 1 
				textbox.change_text("What?? I thought stopping Grimm would fix it for sure...", "red")
			elif conversation_step == 5:
				conversation_step +=1
				textbox.change_text("Yes he does seem the type, doesn't he? Alas there must be something else causing the disaster. Your work isn't quite done yet." , "prof")
			elif conversation_step == 6:
				conversation_step +=1 
				textbox.change_text("*** You beat the game demo! Congrats! You can probably replay it with minimal breaking if you want.***", "red")
			elif conversation_step == 7:
				conversation_step = 1
				Variables.inputIsDisabled = false
				currentconversation = ""
				Game.inventorylock = false
				get_node("Player/AnimatedSprite2D").flip_h = false
				get_node("UI/Textboxanims").play_backwards("textboxappears")
				get_node("UI/Textbox").disabletext = true
				
		elif currentconversation == "exitconvo":
			conversation_step = 1
			Variables.inputIsDisabled = false
			currentconversation = ""
			Game.inventorylock = false
			get_node("Player/AnimatedSprite2D").flip_h = false
			get_node("UI/Textboxanims").play_backwards("textboxappears")
			get_node("UI/Textbox").disabletext = true
			
		else:
			if Game.runs == 0:
				if conversation_step == 1:
					conversation_step = 2 
					get_node("UI/Textbox").change_text("[i]whisper whisper[/i]", "prof")
				elif conversation_step == 2:
					conversation_step = 3 
					get_node("UI/Textbox").change_text("Yes, she does look the type... What's your name?", "prof")
				elif conversation_step == 3:
					conversation_step = 4 
					get_node("UI/Textbox").change_text("My name's Red.", "red")
					get_node("Blue").scale.x = 1
				elif conversation_step == 4:
					conversation_step = 5
					get_node("UI/Textbox").change_text("I could've guessed that to be honest.", "blue")
				elif conversation_step == 5:
					conversation_step = 6
					get_node("UI/Textbox").change_text("Yes, yes. Well, I'm sure Blue here has already told you about me. My name is The Professor.", "prof")
				elif conversation_step == 6:
					conversation_step = 7
					get_node("UI/Textbox").change_text("You know, if there's one thing we do well it's naming. I saw one of the human's names while I was sneaking about in there. Jonathan! Can you believe it? How do they remember that???", "blue")
				elif conversation_step == 7:
					conversation_step = 8
					get_node("UI/Textbox").change_text("Yes, yes. Now Red, I'm sure my assistant Blue has told you all about your task already?", "prof")
				elif conversation_step == 8:
					conversation_step = 9
					get_node("UI/Textbox").change_text("Hey, I never agreed to that title!", "blue")
				elif conversation_step == 9:
					conversation_step = 10
					get_node("UI/Textbox").change_text("No, your assistant didn't tell me almost anything actually...", "red")
				elif conversation_step == 10:
					conversation_step = 11
					get_node("UI/Textbox").change_text("I told you you were an alien!", "blue")
				elif conversation_step == 11:
					conversation_step = 12
					get_node("UI/Textbox").change_text("You didn't know??", "prof")
				elif conversation_step == 12:
					conversation_step = 13
					get_node("UI/Textbox").change_text("She has memory issues. That shouldn't matter though, right prof?", "blue")
				elif conversation_step == 13:
					conversation_step = 14
					get_node("UI/Textbox").change_text("No, I suppose not. And yet she remembered her name. What else do you remember, Red?", "prof")
				elif conversation_step == 14:
					conversation_step = 15
					get_node("UI/Textbox").change_text("My name isn't easy to forget. I also remembered my gun.", "red")
				elif conversation_step == 15:
					conversation_step = 16
					get_node("UI/Textbox").change_text("Aha! A perfect hero! Well, here's the situation. My machine here says a disaster is about to happen approximately here and quite soon.", "prof")
				elif conversation_step == 16:
					conversation_step = 17
					get_node("UI/Textbox").change_text("That's why we came here!", "blue")
				elif conversation_step == 17:
					conversation_step = 18
					get_node("UI/Textbox").change_text("Precisely. And that's why Blue sought you out. Or someone like you.", "prof")
				elif conversation_step == 18:
					conversation_step = 19
					get_node("UI/Textbox").change_text("So you bought me here to clean up your mess? Do your dirty work?", "red")
				elif conversation_step == 19:
					conversation_step = 20
					get_node("UI/Textbox").change_text("Oh my, no! This disaster could be catastrophic for thousands, hundreds of thousands, millions even!", "prof")
				elif conversation_step == 20:
					conversation_step = 21
					get_node("UI/Textbox").change_text("Bajillions! Also when you think about it, you owe me! For freeing you!", "blue")
				elif conversation_step == 21:
					conversation_step = 22
					get_node("UI/Textbox").change_text("Ok, you've convinced me. Bad thing, I fix. This seems a little dangerous though. How can I solve anything?", "red")
				elif conversation_step == 22:
					conversation_step = 23
					get_node("UI/Textbox").change_text("You're a hero! Also don't worry too much - if things go disasterously wrong, we have a time machine! We can bring you back right here to try again, with only some minor time anombalies.", "blue")
				elif conversation_step == 23:
					conversation_step = 24
					get_node("UI/Textbox").change_text("Time anomalies, yes. Things will change each time we bring you back in time, but don't worry too much about that. We will only need to do it if things go spectacularly wrong.", "prof")
				elif conversation_step == 24:
					conversation_step = 25
					get_node("UI/Textbox").change_text("That's reassuring. And what exactly is this disaster?", "red")
				elif conversation_step == 25:
					conversation_step = 26
					get_node("UI/Textbox").change_text("That's the best part! We don't know!", "blue")
				elif conversation_step == 26:
					conversation_step = 27
					get_node("UI/Textbox").change_text("The machine isn't very... Specific. We know the time, which is soon. We know the place, which is here. And we know whether it is going to happen or has already happened, but that's all.", "prof")
				elif conversation_step == 27:
					conversation_step = 28
					get_node("UI/Textbox").change_text("I guess I can't complain much since you did rescue me. Ok, I guess I'll be off then.", "red")
				elif conversation_step == 28:
					conversation_step = 29
					get_node("UI/Textbox").change_text("Off you go then, step into that portal over there and just... Do your thing.", "prof")	
				elif conversation_step == 29:
					conversation_step = 30
					get_node("UI/Textbox").change_text("Good luck!", "blue")
				elif conversation_step == 30:
					conversation_step = 31
					Variables.inputIsDisabled = false
					Game.inventorylock = false
					get_node("Player/AnimatedSprite2D").flip_h = false
					get_node("UI/Textboxanims").play_backwards("textboxappears")
					get_node("UI/Textbox").disabletext = true
					#get_node("TransitionScreen").transition()
			elif Game.runs == 1:
				if conversation_step == 1:
					conversation_step = 2 
					get_node("Blue").scale.x = 1
					textbox.change_text("Wow, thank goodness this thing works! I wasn't sure.", "blue")
				elif conversation_step == 2:
					conversation_step += 1
					textbox.change_text("Y- you didn't know???","red")
				elif conversation_step == 3:
					conversation_step += 1
					textbox.change_text("Well we didn't know for sure. I mean, how could we have? Not like either of us have died before.","blue")
				elif conversation_step == 4:
					conversation_step += 1
					textbox.change_text("I guess...","red")
				elif conversation_step == 5:
					conversation_step += 1
					textbox.change_text("Besides, dying can't be that bad, right?","blue")
				elif conversation_step == 6:
					conversation_step += 1
					textbox.change_text("No? Well maybe you should give it a tr-","red")
				elif conversation_step == 7:
					conversation_step += 1
					textbox.change_text("Now now, that's enough of that. My apologies for my assista-","prof")
				elif conversation_step == 8:
					conversation_step += 1
					textbox.change_text("Associate!","blue")
				elif conversation_step == 9:
					conversation_step += 1
					textbox.change_text("... Well, regardless I hope that wasn't enough to make you give up on the mission. I know death hurts, but technically although you remember it happening, it didn't happen. Because we undid it.","prof")
				elif conversation_step == 10:
					conversation_step += 1
					textbox.change_text("No, no. I'll just try harder to avoid it next time. Any advice for me?","red")
				elif conversation_step == 11:
					conversation_step += 1
					textbox.change_text("You may have figured this out already but our scanners indicate that the base has some commissaries for the employees. If you catch a guard sleeping, don't feel bad about giving yourself a bit of a discount.","prof")
				elif conversation_step == 12:
					conversation_step += 1
					textbox.change_text("Remember that Blue is always on your side!","blue")
				elif conversation_step == 13:
					conversation_step += 1
					textbox.change_text("Right, thanks... Well, no time to waste I suppose.","red")
				elif conversation_step == 14:
					conversation_step += 1
					Variables.inputIsDisabled = false
					Game.inventorylock = false
					get_node("Player/AnimatedSprite2D").flip_h = false
					get_node("UI/Textboxanims").play_backwards("textboxappears")
					get_node("UI/Textbox").disabletext = true

			
func _on_transition_screen_transitioned():
	if player_in_portal:
		get_tree().change_scene_to_file("res://scene/levels/item_room.tscn")
		Game.roomcount = 0 
		


func _on_portal_body_entered(body):
	if body.name == "Player":
		player_in_portal = true

func _on_portal_body_exited(body):
	if body.name == "Player":
		player_in_portal = false


func _on_prof_conversation_prof():
	get_node("UI/Textbox").disabletext = false
	Variables.inputIsDisabled = true
	get_node("UI/Textboxanims").play("textboxappears")
	if current_prof_convo == "prof_1":
		get_node("UI/Textbox").change_text("Sorry you have to go through this. I hope you will soon see the importance of your work here.", "prof")
		currentconversation = "prof_1"
		Variables.prof_conversation_tracker.append("prof_1")
	if current_prof_convo == "prof_2":
		get_node("UI/Textbox").change_text("Hello again Red. Keeping up the good work I see.", "prof")
		currentconversation = "prof_2"
		Variables.prof_conversation_tracker.append("prof_2")
	if current_prof_convo == "prof_3":
		get_node("UI/Textbox").change_text("Haha! Well done Red. I watched you slaying the foul beast.", "prof")
		currentconversation = "prof_3"
		Variables.prof_conversation_tracker.append("prof_3")
	if current_prof_convo == "prof_4":
		get_node("UI/Textbox").change_text("I am surprised your tactics worked. Well done, but if you don't use your actual gun I'm afraid you may wander into peril later...", "prof")
		currentconversation = "prof_4"
		Variables.prof_conversation_tracker.append("prof_4")
	if current_prof_convo == "prof_5":
		get_node("UI/Textbox").change_text("Well, better luck next time I suppose. There is something sinister about that creature...", "prof")
		currentconversation = "exitconvo"
		Variables.prof_conversation_tracker.append("prof_5")

func _on_blue_conversation_blue():
	get_node("UI/Textbox").disabletext = false
	Variables.inputIsDisabled = true
	get_node("UI/Textboxanims").play("textboxappears")
	if current_blue_convo == "blue_1":
		get_node("UI/Textbox").change_text("Hey, sorry about earlier. Sometimes I just say things without thinking it throu-", "blue")
		currentconversation = "blue_1"
		Variables.blue_conversation_tracker.append("blue_1")
	if current_blue_convo == "blue_2":
		get_node("UI/Textbox").change_text("Red!", "blue")
		currentconversation = "blue_2"
		Variables.blue_conversation_tracker.append("blue_2")
	if current_blue_convo == "blue_3":
		get_node("UI/Textbox").change_text("That was very... Bloody. I don't mean that in a bad way of course. That is why we needed you, after all! But erm...", "blue")
		currentconversation = "blue_3"
		Variables.blue_conversation_tracker.append("blue_3")
	if current_blue_convo == "blue_4":
		get_node("UI/Textbox").change_text("You did it! You're my hero, did I ever tell you that? But erm...", "blue")
		currentconversation = "blue_4"
		Variables.blue_conversation_tracker.append("blue_4")
	if current_blue_convo == "blue_5":
		get_node("UI/Textbox").change_text("Ah, shoot. Well, there's always next time. if it makes you feel any better, we got you out of there before he bloodied you up too bad!", "blue")
		currentconversation = "exitconvo"
		Variables.blue_conversation_tracker.append("blue_5")
