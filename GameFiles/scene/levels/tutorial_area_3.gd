extends Node2D


var wtf = preload("res://scene/mob/wtf.tscn")
@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")
var gun1_picked_up = false
var gun2_picked_up = false
signal gunspickedup


# Called when the node enters the scene tree for the first time.
func _ready():
	player.update_ammo.connect(_on_player_update_ammo)
	player.update_gun.connect(_on_player_update_gun)
	player.update_health.connect(_on_update_health)
	Utils.unpausegame()
	get_node("UI/Textbox").visible = false
	get_node("UI").visible = true
	
	#get_tree().reload_current_scene()
	#player.update_health.connect(_on_update_health)
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = false
		if Game.gun_list.size() > 1:
			get_node("UI/sidearm/gun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
			get_node("UI/sidearm/toygun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = true
		if Game.gun_list.size() > 1:
			get_node("UI/sidearm/gun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = true
			get_node("UI/sidearm/toygun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Game.weapon_equipped == "gun" and Input.is_action_just_pressed("ui_left_click") and get_node("speechtimer").is_stopped():
		var rng = RandomNumberGenerator.new()
		var randout = rng.randi_range(1,4)
		var bang = wtf.instantiate()
		var locationmodx = rng.randi_range(-15,15)
		get_node("speechtimer").start()
		bang.position = player.global_position
		bang.position.x += locationmodx
		bang.position.y -= 15
		if randout == 1:
			bang.settext("Heavy sleeper...")
		elif randout == 2:
			bang.settext("BANG!")
		elif randout == 3:
			bang.settext("Do I need a license?")
		elif randout == 4:
			bang.settext("I should leave before he wakes up.")
		bang.modulate = Color(1,0,0,1)
		get_parent().add_child(bang)
	elif Game.weapon_equipped == "toygun" and Input.is_action_just_pressed("ui_left_click") and get_node("speechtimer").is_stopped():
		var rng = RandomNumberGenerator.new()
		var randout = rng.randi_range(1,4)
		var bang = wtf.instantiate()
		var locationmodx = rng.randi_range(-15,15)
		get_node("speechtimer").start()
		bang.position = player.global_position
		bang.position.x += locationmodx
		bang.position.y -= 15
		if randout == 1:
			bang.settext("My trusty gun!")
		elif randout == 2:
			bang.settext("I was wondering where they put this...")
		elif randout == 3:
			bang.settext("Make love not war!")
		elif randout == 4:
			bang.settext("I should leave before he wakes up.")
		bang.modulate = Color(1,0,0,1)
		get_parent().add_child(bang)
	
	if gun1_picked_up and gun2_picked_up:
		get_node("Tutorial_area_1_door").add_to_group("interact")
		gunspickedup.emit()
	
	
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = false
		if Game.gun_list.size() == 1:
			get_node("UI/sidearm/gun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
			get_node("UI/sidearm/toygun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false
		elif Game.gun_list.size() == 2:
			get_node("UI/sidearm/gun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
			get_node("UI/sidearm/toygun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = true
			
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = true
		if Game.gun_list.size() == 1:
			get_node("UI/sidearm/gun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
			get_node("UI/sidearm/toygun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false
		elif Game.gun_list.size() == 2:
			get_node("UI/sidearm/gun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = true
			get_node("UI/sidearm/toygun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false

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
		if Game.gun_list.size() > 1:
			get_node("UI/sidearm/gun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = false
			get_node("UI/sidearm/toygun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/equipped_gun/toygun").visible = true
		if Game.gun_list.size() > 1:
			get_node("UI/sidearm/gun").visible = true
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/gun").visible = true
			get_node("UI/sidearm/toygun").visible = false
			get_node("UI/Inventory/Tutorial UI/GUI/background/VBoxContainer/sidearm/toygun").visible = false



func _on_area_2d_gun_1():
	gun1_picked_up = true


func _on_area_2d_gun_2():
	gun2_picked_up = true
