extends Node2D


@onready var hpbar = get_node("UI/player_health")
@onready var player = get_node("Player")
@onready var ammobar = get_node("UI/Ammo")


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().reload_current_scene()
	player.update_health.connect(_on_update_health)
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/sidearm/gun").visible = false
		get_node("UI/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/sidearm/gun").visible = true
		get_node("UI/sidearm/toygun").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel") and $UI/pause_modulation/Continue.visible == false or Game.playerDied:
		$UI/pause_modulation/Continue.show()
		$UI/pause_modulation/Quit.show()
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
	
	var abilitycount = Game.current_abilities.size()
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

func _on_menu_button_pressed():
	if !Game.playerDied:
		Utils.pausegame()
		$UI/pause_modulation/Continue.hide()
		$UI/pause_modulation/Quit.hide()
	elif Game.playerDied:
		Game._gamereset()
		get_tree().change_scene_to_file("res://scene/levels/main.tscn")



func _on_quit_pressed():
	get_tree().quit()
	


func _on_player_update_ammo():
	ammobar.value = Game.currentammo
	


func _on_player_update_gun():
	if Game.weapon_equipped == "gun":
		get_node("UI/equipped_gun/gun").visible = true
		get_node("UI/equipped_gun/toygun").visible = false
		get_node("UI/sidearm/gun").visible = false
		get_node("UI/sidearm/toygun").visible = true
	elif Game.weapon_equipped == "toygun":
		get_node("UI/equipped_gun/gun").visible = false
		get_node("UI/equipped_gun/toygun").visible = true
		get_node("UI/sidearm/gun").visible = true
		get_node("UI/sidearm/toygun").visible = false
