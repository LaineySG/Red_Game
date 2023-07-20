extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	var stat = int(get_node("OptionButton").selected)
	var setTo = int(get_node("LineEdit").text)
	if stat == 9: 
		stat = "ALL"
	elif stat == 0:
		stat = "Shot Speed"
	elif stat == 1:
		stat = "Shot Weight"
	elif stat == 2:
		stat = "Punch"
	elif stat == 3:
		stat = "Magazine Size"
	elif stat == 4:
		stat = "Reload Speed"
	elif stat == 5:
		stat = "Fire Rate"
	elif stat == 6:
		stat = "Bullet Size"
	elif stat == 7:
		stat = "Scope"
	elif stat == 8:
		stat = "HP"
	elif stat == 10:
		stat = "Regeneration"
	elif stat == 11:
		stat = "Alacrity"
	elif stat == 12:
		stat = "Luck"
		
	if stat == "HP" or stat == "ALL":
		Game.playerstats["HP"] = setTo
	if stat == "Reload Speed" or stat == "ALL":
		Game.playerstats["Reload Speed"] = setTo
	if stat == "Fire Rate" or  stat == "ALL":
		Game.playerstats["Fire Rate"] = setTo
	if stat == "Bullet Size" or stat == "ALL":
		Game.playerstats["Bullet Size"] = setTo
	if stat == "Scope" or stat == "ALL":
		Game.playerstats["Scope"] = setTo
	if stat == "Shot Speed" or stat == "ALL":
		Game.playerstats["Shot Speed"] = setTo
	if stat == "Shot Weight" or stat == "ALL":
		Game.playerstats["Shot Weight"] = setTo
	if stat == "Punch" or stat == "ALL":
		Game.playerstats["Punch"] = setTo
	if stat == "Magazine Size" or stat == "ALL":
		Game.playerstats["Magazine Size"] = setTo
	if stat == "Regeneration" or stat == "ALL":
		Game.playerstats["Regeneration"] = setTo
	if stat == "Alacrity" or stat == "ALL":
		Game.playerstats["Alacrity"] = setTo
	if stat == "Luck" or stat == "ALL":
		Game.playerstats["Luck"] = setTo


func _on_button_2_pressed():#reset block
	
	for j in range(Game.modifications.size()): # for each modification
		var modtocheck = Game.modifications[j] #set modtocheck to that modification
		Game.playerstats[modtocheck] = 0


func _on_effect_reset_pressed():
	Game.current_effects = []


func _on_effect_set_pressed():
	var stat = int(get_node("Effect_name").selected)
	stat = get_node("Effect_name").get_item_text(stat)
	var setTo = int(get_node("Effect_bool").text)
	if setTo == 0:
		if Game.current_effects.has(stat):
			var i = Game.current_effects.find(stat)
			Game.current_effects.erase(i)
		else:
			pass
	if setTo == 1:
		if Game.current_effects.has(stat):
			pass
		else:
			Game.current_effects.append(stat)
		


func _on_ability_reset_pressed():
	Game.current_abilities = {}


func _on_ability_set_pressed():
	var abilityname = int(get_node("ability_name").selected)
	abilityname = get_node("ability_name").get_item_text(abilityname)
	var abilitykey = int(get_node("ability_key").selected)
	abilitykey = get_node("ability_key").get_item_text(abilitykey)
	var setTo = int(get_node("ability_bool").text)
	if setTo == 0:
		if Game.current_abilities.has(abilityname):
			var i = Game.current_abilities.find(abilityname)
			Game.current_abilities.erase(i) #pop?
		else:
			pass
	if setTo == 1:
		if Game.current_abilities.has(abilityname):
			pass
		else:
			Game.current_abilities[abilityname] = str(abilitykey)
