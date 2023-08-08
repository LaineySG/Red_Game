extends Node

var playerhp = 100
var playerhpmax = 100
var playergold = 0
var has_gun = 1
var toy_kill_counter = 0
var givenabilities = [] # ensures player doesn't get same ability item twice/run
var gun_kill_counter = 0
var grimm_gun_kill_counter = 0
var grimm_toy_kill_counter = 0
var ammomax
var runs = 0
var has_toy_gun = 1
var playerDied = false
var currentammo = 7
var currenttoyammo = 7
var berserkshotcount = 0
var tutorial_area2count = 0
var roomcount = 0
var playershottimer = 0.4
var inventorylock = false
var modifications = ["Shot Speed", "Shot Weight", "Punch", "Magazine Size", "Reload Speed", "Fire Rate", "Bullet Size", "Scope", "HP","Regeneration", "Luck", "Alacrity"]
var playerstats = {
	"Shot Speed":0, 
	"Shot Weight":0, 
	"Punch":0, 
	"Magazine Size":0, 
	"Reload Speed":0, 
	"Fire Rate":0, 
	"Bullet Size":0, 
	"Scope":0, 
	"HP":0,
	"Regeneration":0,
	"Luck":0,
	"Alacrity":0,
	}
var current_abilities = {}
var gun_list = ["gun", "toygun"]
var weapon_equipped = gun_list[0] # gun or toygun
var items_list = []
var equipped_items = []
var current_effects = []


var current_effects_levels = {}
var current_abilities_levels = {}

var eqptracker = 0
var abilityCDs = {}
var eqptracker2 = []


func _gamereset():
	playerhp = 100
	playerhpmax = 100
	playergold = 0
	has_gun = 1
	has_toy_gun = 1
	givenabilities = []
	playerDied = false
	currentammo = 7
	currenttoyammo = 7
	berserkshotcount = 0
	playershottimer = 0.4
	inventorylock = false

	modifications = ["Shot Speed", "Shot Weight", "Punch", "Magazine Size", "Reload Speed", "Fire Rate", "Bullet Size", "Scope", "HP","Regeneration", "Luck", "Alacrity"]

	playerstats = {
		"Shot Speed":0, 
		"Shot Weight":0, 
		"Punch":0, 
		"Magazine Size":0, 
		"Reload Speed":0, 
		"Fire Rate":0, 
		"Bullet Size":0, 
		"Scope":0, 
		"HP":0,
		"Regeneration":0, 
		"Luck":0, 
		"Alacrity":0
		}
	current_abilities = {}

	gun_list = ["gun", "toygun"]
	items_list = []
	equipped_items = []
	current_effects = []
	eqptracker = 0
	eqptracker2 = []

	Variables.current_room_items = {}
	Variables.current_room_doors = {}
	Variables.current_room_enemies = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ammomax = (int(round(playerstats["Magazine Size"] * 14 / 20))) + 7
	currentammo = ammomax
	currenttoyammo = ammomax
	
func newRoom():
	Game.inventorylock = false
#	print("-------------------------------")
#	print("runs: " + str(runs))
#	print("roomcount: " + str(roomcount))
#	var equipped_item_names = []
#	for i in equipped_items:
#		equipped_item_names.append(i.get("ID"))
#		equipped_item_names.append(i.get("EquipSlot").left(6))
#	print("equipped_items: " + str(equipped_item_names))
#	var item_names = []
#	for i in items_list:
#		item_names.append(i.get("ID"))
#		if i.get("EquipSlot") != null:
#			item_names.append(i.get("EquipSlot").left(6))
#	print("items_list:  " + str(item_names))
#	print("toy kills: " + str(toy_kill_counter))
#	print("gun kills: " + str(gun_kill_counter))
	
func refreshEffects():
		current_effects = []
		current_effects_levels = {}
		current_abilities = {}
		current_abilities_levels = {}
		for i in equipped_items: # for each equipped item
			var inspect = str(i["EquipSlot"])
			if inspect.left(5) == "Major":
				if i.get("Effect") != null:
					var level
					if i.get("Level") == "I":
						level = 1
					elif i.get("Level") == "II":
						level = 2
					elif i.get("Level") == "III":
						level = 3
					elif i.get("Level") == "IV":
						level = 4
					elif i.get("Level") == "V":
						level = 5
						
					current_effects.append(i.get("Effect"))
					
					
					if current_effects_levels.get(str(i.get("Effect"))): #if already exists:
						if current_effects_levels.get(str(i.get("Effect"))) < 5: # if currently less than 5
							var totallevel = current_effects_levels.get(str(i.get("Effect"))) + level
							if totallevel > 5:
								totallevel = 5
							current_effects_levels[str(i.get("Effect"))] = totallevel
					else:
						current_effects_levels[str(i.get("Effect"))] = level
						
					
			if inspect.left(5) == "Abili":
				if i.get("Ability") != null:
					var level
					if i.get("Level") == "I":
						level = 1
					elif i.get("Level") == "II":
						level = 2
					elif i.get("Level") == "III":
						level = 3
					elif i.get("Level") == "IV":
						level = 4
					elif i.get("Level") == "V":
						level = 5
					current_abilities[str(i.get("Ability"))] = inspect.left(6).right(1)
					
					if current_abilities_levels.get(str(i.get("Ability"))): #if already exists:
						if current_abilities_levels.get(str(i.get("Ability"))) < 5: # if currently less than 5
							var totallevel = current_abilities_levels.get(str(i.get("Ability"))) + level
							if totallevel > 5:
								totallevel = 5
							current_abilities_levels[str(i.get("Ability"))] = totallevel
					else:
						current_abilities_levels[str(i.get("Ability"))] = level
						
					
	
	
func refreshstats():
	playerstats = {"Shot Speed":0, "Shot Weight":0, "Punch":0, "Magazine Size":0, "Reload Speed":0, "Fire Rate":0, "Bullet Size":0, "Scope":0, "HP":0, "Regeneration":0, "Luck": 0, "Alacrity": 0}
	
	for i in equipped_items: # for each equipped item
		#var modvartracker = 0
		for j in range(modifications.size()): # for each modification
			
			var modtocheck = modifications[j] #set modtocheck to that modification
			if i.get("mod0raw") != null: #if the mod exists
				if i["mod0raw"] == modtocheck: #and is equal to the modification being checked for
					playerstats[modtocheck] += i.get("mod0bonus") #Add the bonus
			if i.get("mod1raw") != null:
				if i["mod1raw"] == modtocheck:
					playerstats[modtocheck] += i.get("mod1bonus")
			if i.get("mod2raw") != null:
				if i["mod2raw"] == modtocheck:
					playerstats[modtocheck] += i.get("mod2bonus")
			if i.get("mod3raw") != null:
				if i["mod3raw"] == modtocheck:
					playerstats[modtocheck] += i.get("mod3bonus")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	ammomax = (int(round(playerstats["Magazine Size"] * 14 / 20))) + 7
	if Input.is_action_just_pressed("ui_end"):
		newRoom()
		
	if playerhp > playerhpmax:
		playerhp = playerhpmax
						
					
	if eqptracker != equipped_items.size() or eqptracker2 != equipped_items: # if number of items in inventory changes
		refreshstats()
		refreshEffects()
		eqptracker = equipped_items.size()
		eqptracker2 = equipped_items
	if Input.is_action_just_released("ui_left_click"):		
		refreshstats()
		refreshEffects()
		
			
	
	for j in range(modifications.size()): # for each modification
		var modtocheck = modifications[j] #set modtocheck to that modification
		if playerstats[modtocheck] > 20:
			playerstats[modtocheck] = 20
		
		
		
	playerhpmax = 100 + (playerstats["HP"] * 10)
	if currentammo > ammomax:
		currentammo = ammomax
	if currenttoyammo > ammomax:
		currenttoyammo = ammomax
		
		
	playershottimer = 0.4 - (playerstats["Fire Rate"] * 0.4 / 20)

		
