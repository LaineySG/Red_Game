extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var wtf = preload("res://scene/mob/wtf.tscn")
var brokemessage = false
var helpcounter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Musicplayer.playsong("relaxed")
	player.update_ammo.connect(_on_player_update_ammo)
	player.update_gun.connect(_on_player_update_gun)
	player.update_health.connect(_on_update_health)
	get_node("UI/Textbox").visible = false
	get_node("UI").visible = true
	
	Utils.unpausegame()
	
	get_node("tutorial_room1/exitdoor/Area2D").locked = true
	
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
	
	if get_node("tutorial_room1/Scifi4d1a").broken and brokemessage == false:
		var rng = RandomNumberGenerator.new()
		brokemessage = true
		var bang = wtf.instantiate()
		var locationmodx = rng.randi_range(-100,-75)
		bang.position = player.global_position
		bang.position.x += locationmodx
		bang.position.y -= 15
		bang.settext("So [i]that's[/i] why they call it a problem solver!")
		bang.modulate = Color(1,0,0,1)
		get_parent().add_child(bang)
		get_node("doorlocked").visible = false
		get_node("Puzzle").visible = false
		
		get_node("tutorial_room1/exitdoor/Area2D").locked = false
		get_node("tutorial_room1/exitdoor").open()
		
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



func _on_timer_timeout():
	if !get_node("tutorial_room1/Scifi4d1a").broken:	
		helpcounter +=1
		var rng = RandomNumberGenerator.new()
		var bang = wtf.instantiate()
		var locationmodx = rng.randi_range(-100,-75)
		bang.position = player.global_position
		bang.position.x += locationmodx
		bang.position.y -= 15
		if helpcounter == 1:
			bang.settext("I wish I had some sort of problem solver...")
		elif helpcounter ==2:
			bang.settext("I heard you miss 100% of the shots you don't take!")
		else:
			bang.settext("I should shoot the computer.")
		bang.modulate = Color(1,0,0,1)
		get_parent().add_child(bang)
			

